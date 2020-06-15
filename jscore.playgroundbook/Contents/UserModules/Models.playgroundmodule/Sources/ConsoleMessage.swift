import Foundation

public enum MessageType {
    case input
    case value
    case debug
    case log
    case info
    case warn
    case error
}

public struct ConsoleMessage {
    public let id = UUID()
    public let text: String
    public let type: MessageType

    public init(text: String, type: MessageType) {
        self.text = text
        self.type = type
    }
}

extension ConsoleMessage: Identifiable {}
