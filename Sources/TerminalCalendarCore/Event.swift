import EventKit
import Foundation

public enum EventStatus {
    case done
    case now
    case future
}

public class Event {
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
        if now.inRange(startDate, and: endDate) {
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

    var zoomLinks: [ZoomLink] {
        let inLocation = findZoomLinks(event.location)

        var inNotes: [ZoomLink] = []
        if event.hasNotes, let notes = event.notes {
            inNotes = findZoomLinks(notes)
        }

        let links = inLocation + inNotes
        return links.reduce([]) {
            $0.contains($1) ? $0 : $0 + [$1]
        }
    }

    var hasZoom: Bool {
        return !zoomLinks.isEmpty
    }

    public init(_ event: EKEvent) {
        self.event = event
    }
}
