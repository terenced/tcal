import EventKit
import Guaka
import SwiftDate
import TerminalCalendarCore

var rootCommand = Command(
    usage: "tcal",
    configuration: configuration,
    run: execute
)

private func configuration(command: Command) {
    command.add(flags: [
        Flag(shortName: "t", longName: "today", value: true, description: "Show today's events"),
        Flag(shortName: "y", longName: "yesterday", value: false, description: "Show yesterday's events"),
        Flag(shortName: "2", longName: "tomorrow", value: false, description: "Show tomorrow's events"),
        Flag(shortName: "d", longName: "date", value: "", description: "Show events for a specific date"),
    ])

    // Other configurations
}

private func execute(flags: Flags, args _: [String]) {
    let store = EKEventStore()

    let localRegion = Region(calendar: Calendar.current, zone: Zones.current)

    var startDate = DateInRegion(region: localRegion).dateAt(.startOfDay).date
    var endDate = DateInRegion(region: localRegion).dateAt(.endOfDay).date
    
    if let dateStr = flags.getString(name: "date") {
        if let date = DateInRegion(dateStr) {
            startDate = date.convertTo(region: localRegion).dateAt(.nearestHour(hour: 8)).date
            endDate = date.dateAt(.endOfDay).date
        }
    }
    else if let tomorrow = flags.getBool(name: "tomorrow"), tomorrow == true {
        startDate = DateInRegion(region: localRegion).dateAt(.tomorrowAtStart).date
        endDate = DateInRegion(region: localRegion).dateAt(.tomorrow).dateAt(.endOfDay).date
    } else if let yesterday = flags.getBool(name: "yesterday"), yesterday == true {
        startDate = DateInRegion(region: localRegion).dateAt(.yesterdayAtStart).date
        endDate = DateInRegion(region: localRegion).dateAt(.yesterday).dateAt(.endOfDay).date
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none

    print("\(startDate)=> \(endDate)")
    let when = dateFormatter.string(from: startDate)
    print(when.s.Bold)

    var predicate: NSPredicate?
    predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

    if let aPredicate = predicate {
        printEventTable(store.events(matching: aPredicate).map { TerminalCalendarCore.Event($0) })
    }
}
