import SwiftUI
import Models

public struct ConsoleMessageCell {
    let systemName: String
    let text: String
    let iconColor: Color?
    let textColor: Color?
    let rowBackground: Color?

    public init(message: ConsoleMessage) {
        self.text = message.text

        switch message.type {
        case .input:
            self.systemName = "greaterthan"
            self.iconColor = nil
            self.textColor = nil
            self.rowBackground = nil
        case .value:
            self.systemName = "arrow.left"
            self.iconColor = .gray
            self.textColor = .gray
            self.rowBackground = nil
        case .debug, .log:
            self.systemName = ""
            self.iconColor = nil
            self.textColor = nil
            self.rowBackground = nil
        case .info:
            self.systemName = "i.circle.fill"
            self.iconColor = .blue
            self.textColor = nil
            self.rowBackground = nil
        case .warn:
            self.systemName = "exclamationmark.triangle.fill"
            self.iconColor = .yellow
            self.textColor = .yellow
            self.rowBackground = Color.yellow.opacity(0.2)
        case .error:
            self.systemName = "xmark.circle.fill"
            self.iconColor = .red
            self.textColor = .red
            self.rowBackground = Color.red.opacity(0.2)
        }
    }
}

extension ConsoleMessageCell: View {
    public var body: some View {
        HStack {
            Image(systemName: self.systemName)
                .foregroundColor(self.iconColor)
            Text(self.text)
                .foregroundColor(self.textColor)
        }
        .listRowBackground(rowBackground)
    }
}
