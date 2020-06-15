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
            HStack {
                Button(action: self.viewModel.clear) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding()
                Spacer()
                Picker("Log Level", selection: self.$viewModel.logLevel) {
                    ForEach(LogLevel.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
            }

            List {
                ForEach(self.viewModel.filteredReversedMessages) {
                    ConsoleMessageCell(message: $0)
                        .flip()
                }
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
