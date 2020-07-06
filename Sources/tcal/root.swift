import EventKit
import Guaka

var rootCommand = Command(
    usage: "tcal",
    configuration: configuration,
    run: execute
)

private func configuration(command: Command) {
    command.add(flags: [
        // Add your flags here
    ])

    // Other configurations
}

private func execute(flags _: Flags, args _: [String]) {
    let store = EKEventStore()

//    let startDate = Date().dateAt(.tomorrowAtStart)
//    let endDate = Date().dateAt(.tomorrow).dateAt(.endOfDay)
    let startDate = Date().dateAt(.startOfDay)
    let endDate = Date().dateAt(.endOfDay)

    var predicate: NSPredicate?
    predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

    if let aPredicate = predicate {
        printEventTable(store.events(matching: aPredicate).map { TcalEvent($0) })
    }
}
