import SwiftUI
import Extensions
import ViewModels

public struct ConsoleView {
    @ObservedObject var viewModel = ConsoleViewModel()

    public init() {}
}

extension ConsoleView: View {
    public var body: some View {
        VStack {
            List(self.viewModel.messages.reversed()) {
                ConsoleMessageCell(message: $0)
                    .flip()
            }
            .flip()

            HStack {
                Image(systemName: "greaterthan")
                CommandLine("Input here...", text: self.$viewModel.input, onReturn: self.viewModel.run)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}
