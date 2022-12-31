import CompletionCommand
import GenCommand
import SwiftCLI

let cli = CLI(name: "sutra", version: "1.0.0", description: "A template engine for any source code")

cli.commands = [
	GenCommand(name: "copy"),
	CompletionCommand(name: "completions", cli: cli)
]

cli.go()
