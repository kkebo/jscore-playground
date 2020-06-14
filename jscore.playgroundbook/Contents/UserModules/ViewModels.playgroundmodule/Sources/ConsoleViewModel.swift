import Combine
import Dispatch
import JavaScriptCoreWrapper
import Models

public enum LogLevel: String, CaseIterable {
    case all
    case log
    case info
    case warn
    case error

    func canShow(type: MessageType) -> Bool {
        switch (self, type) {
        case (_, .input), (_, .value): return true
        case (.all, _): return true
        case (.log, .log), (.log, .info), (.log, .warn), (.log, .error):
            return true
        case (.log, _):
            return false
        case (.info, .info), (.info, .warn), (.info, .error):
            return true
        case (.info, _):
            return false
        case (.warn, .warn), (.warn, .error):
            return true
        case (.warn, _):
            return false
        case (.error, .error):
            return true
        case (.error, _):
            return false
        }
    }
}

public final class ConsoleViewModel {
    @Published public var input = ""
    @Published public var messages = [ConsoleMessage]()
    @Published public var logLevel = LogLevel.all

    let context = JSContext()

    public var filteredReversedMessages: [ConsoleMessage] {
        self.messages
            .lazy
            .filter { self.logLevel.canShow(type: $0.type) }
            .reversed()
    }

    public init() {
        self.context.exceptionHandler = { _, exception in
            let string = exception!.toString()
            self.messages.append(ConsoleMessage(text: string, type: .error))
        }
    }

    public func run() {
        self.messages.append(ConsoleMessage(text: self.input, type: .input))

        let result = self.context.evaluateScript(self.input).toString()
        self.messages.append(ConsoleMessage(text: result, type: .value))

        self.input = ""
    }
}

extension ConsoleViewModel: ObservableObject {}
