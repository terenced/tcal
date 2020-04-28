import Colorizer
import EventKit
import SwiftDate
import SwiftyTextTable

private func printStatus(_ status: EventStatus) -> String {
    switch status {
    case .done:
        return "✓"
    case .now:
        return "→"
    case .future:
        return "→"
    }
}

private func printDesc(_ text: String, isDone: Bool) -> String {
    let formattedText = text.f.Magenta
    return isDone ? formattedText.s.Strikethrough : formattedText.s.Bold
}

func printEventTable(_ events: [Event]?) {
    if events?.count == 0 {
        print("👾 All done!".f.Cyan)
        return
    }

    let localRegion = Region(calendar: Calendar.current, zone: Zones.current)

    let status = TextTableColumn(header: "")
    let when = TextTableColumn(header: "")
    let desc = TextTableColumn(header: "")

    var table = TextTable(columns: [status, when, desc])
    table.columnFence = ""
    table.rowFence = ""
    table.cornerFence = ""
    let timeFormat = "HH:mm"

    for event in events ?? [] {
        if event.isAllDay {
            // TODO: Only filter if a flag is provied
            continue
        }
        table.addRow(values: [
            printStatus(event.status),
            "\(event.startDate.convertTo(region: localRegion).toFormat(timeFormat))".s.Bold,
            printDesc(event.title, isDone: event.isDone),
        ])
        if event.hasZoom {
            let head = event.zoomLinks.first
            let rest = event.zoomLinks.dropFirst()

            table.addRow(values: [
                "",
                event.startDate.toRelative().s.Italic,
                head!.link.s.Italic.f.Yellow,
            ])
            rest.forEach {
                table.addRow(values: [
                    "",
                    "",
                    $0.link.s.Italic.f.Yellow,
                ])
            }
        }
        table.addRow(values: [])
    }

    let rendering = table.render().trimmingCharacters(in: .whitespacesAndNewlines)
    print(" " + rendering)
}
