import SwiftUI

public struct CommandLine: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let onReturn: () -> Void

    public init(_ placeholder: String, text: Binding<String>, onReturn: @escaping () -> Void) {
        self.placeholder = placeholder
        self._text = text
        self.onReturn = onReturn
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(text: self.$text, onReturn: self.onReturn)
    }

    public func makeUIView(context: UIViewRepresentableContext<CommandLine>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CommandLine>) {
        uiView.text = self.text
    }
}

extension CommandLine {
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let onReturn: () -> Void

        init(text: Binding<String>, onReturn: @escaping () -> Void) {
            self._text = text
            self.onReturn = onReturn
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.text = textField.text ?? ""
            if text.count > 0 {
                self.onReturn()
            }
            return false
        }
    }
}
