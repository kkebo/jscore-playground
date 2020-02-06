public struct ConsoleMessage {
    public enum MessageType {
        case input
        case value
        case log
        case info
        case warn
        case error
    }
    public let text: String
    public let type: MessageType

    public init(text: String, type: MessageType) {
        self.text = text
        self.type = type
    }
}

extension ConsoleMessage: Hashable {}
