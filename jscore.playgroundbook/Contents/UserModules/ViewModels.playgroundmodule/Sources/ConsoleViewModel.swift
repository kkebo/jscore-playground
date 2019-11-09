import Combine
import Dispatch
import JavaScriptCoreWrapper
import Models

public class ConsoleViewModel: ObservableObject {
    @Published public var input = ""
    @Published public var messages = [ConsoleMessage]()

    let context = JSContext()

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
