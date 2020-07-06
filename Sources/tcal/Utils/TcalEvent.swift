import EventKit
import Foundation

enum EventStatus {
    case done
    case now
    case future
}

class TcalEvent {
    private var event: EKEvent
    var startDate: Date {
        return event.startDate
    }

    var endDate: Date {
        return event.endDate
    }

    var title: String {
        return event.title
    }

    var isAllDay: Bool {
        return event.isAllDay
    }

    var status: EventStatus {
        let now = Date()
        if now.isBetween(startDate, and: endDate) {
            return EventStatus.now
        } else if endDate <= now {
            return EventStatus.done
        }
        return EventStatus.future
    }

    var isDone: Bool {
        return status == .done
    }

    var description: String {
        return event.description
    }

    var location: String {
        if let location = event.location {
            return location
        }
        return ""
    }

    var notes: String {
        if event.hasNotes {
            return event.notes!
        }
        return ""
    }

    var zoomLink: String? {
        if let location = event.location {
            if let link = extractZoom(location) {
                return link
            }
        }

        if event.hasNotes, let notes = event.notes {
            if let link = extractZoom(notes) {
                return link
            }
        }

        return nil
    }

    var hasZoom: Bool {
        return zoomLink != nil
    }

    init(_ event: EKEvent) {
        self.event = event
    }

    private func extractZoom(_ text: String) -> String? {
        let pattern = #"https\:\/\/[\w]*\.zoom.us\/\w\/(?<id>\d{9,11})(\?pwd=(?<pwd>[\w|\d]*)\")*"#
        let nsrange = NSRange(text.startIndex ..< text.endIndex, in: text)
        var metaDict = [String: String]()

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            if let match = regex.firstMatch(in: text, options: [], range: nsrange) {
                for component in ["id", "pwd"] {
                    let nsrange = match.range(withName: component)
                    if nsrange.location != NSNotFound,
                        let range = Range(nsrange, in: text) {
                        metaDict[component] = "\(text[range])"
                    }
                }
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
        }

        if metaDict.isEmpty {
            return ""
        }

        if let id = metaDict["id"] {
            let zoomlink = "zoommtg://zoom.us/join?action=join&confno=\(id)"
            if let pwd = metaDict["pwd"] {
                return zoomlink + "&pwd=\(pwd)"
            }
            return zoomlink
        }

        return nil
    }
}
