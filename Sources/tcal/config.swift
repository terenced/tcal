import Guaka

var configCommand = Command(
    usage: "config",
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
    // Execute code here
    print("config called")
}
