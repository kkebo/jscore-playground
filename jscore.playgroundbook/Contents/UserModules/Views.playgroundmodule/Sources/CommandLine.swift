import SwiftUI

public struct CommandLine {
    @Binding var text: String
    let placeholder: String
    let onReturn: () -> Void

    public init(_ placeholder: String, text: Binding<String>, onReturn: @escaping () -> Void) {
        self.placeholder = placeholder
        self._text = text
        self.onReturn = onReturn
    }
}

extension CommandLine: UIViewRepresentable {
    public func makeCoordinator() -> Self.Coordinator {
        Self.Coordinator(text: self.$text, onReturn: self.onReturn)
    }

    public func makeUIView(context: Self.Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Self.Context) {
        uiView.text = self.text
    }
}

extension CommandLine {
    public final class Coordinator: NSObject {
        @Binding var text: String
        let onReturn: () -> Void

        init(text: Binding<String>, onReturn: @escaping () -> Void) {
            self._text = text
            self.onReturn = onReturn
        }
    }
}

extension CommandLine.Coordinator: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.text = textField.text ?? ""
        if text.count > 0 {
            self.onReturn()
        }
        return false
    }
}
