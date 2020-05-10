import Combine
import Dispatch
import WebKit
import Models

public class ConsoleViewModel: ObservableObject {
    @Published public var input = ""
    @Published public var messages = [ConsoleMessage]()

    let webView = WKWebView()
    
    public init() {}

    public func run() {
        self.messages.append(ConsoleMessage(text: self.input, type: .input))

        self.webView.evaluateJavaScript(self.input) { value, error in
            if let error = error {
                self.messages.append(ConsoleMessage(text: error.localizedDescription, type: .error))
                return
            }
            
            switch value {
            case let value as String:
                self.messages.append(ConsoleMessage(text: value, type: .value))
            case let value as Int:
                self.messages.append(ConsoleMessage(text: value.description, type: .value))
            case let value as Double:
                self.messages.append(ConsoleMessage(text: value.description, type: .value))
            case let .some(value):
                self.messages.append(ConsoleMessage(text: "\(value)", type: .value))
            case let .none:
                self.messages.append(ConsoleMessage(text: "null", type: .value))
            }
        }

        self.input = ""
    }
}
