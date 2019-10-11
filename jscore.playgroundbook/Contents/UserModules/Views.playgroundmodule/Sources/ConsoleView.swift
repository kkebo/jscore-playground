import SwiftUI
import ViewModels

public struct ConsoleView: View {
    @ObservedObject var viewModel: ConsoleViewModel

    public init(viewModel: ConsoleViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.messages, id: \.self.text) {
                    ConsoleMessageCell(message: $0)
                }
            }
            HStack {
                Image(systemName: "greaterthan")
                CommandLine("Input here...", text: self.$viewModel.input, onReturn: self.viewModel.run)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}
