import UIKit
import PlaygroundSupport

Bundle(path: "/System/Library/Frameworks/JavaScriptCore.framework")?.load()
let JSContextClass = NSClassFromString("JSContext") as? NSObject.Type

class ViewController: UIViewController, UITextFieldDelegate {
    var context: NSObject = {
        guard let instance = JSContextClass?.init() as? NSObject else { fatalError() }
        return instance
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.font = UIFont(name: "Menlo", size: 14)
        textView.isEditable = false
        return textView
    }()
    private let prompt: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type JavaScript code here"
        textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.font = UIFont(name: "Menlo", size: 14)
        textField.autocapitalizationType = .none
        textField.smartDashesType = .no
        textField.smartQuotesType = .no
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearButtonMode = .always
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context.setValue({ (_, exception: NSObject!) in
            guard let string = exception.perform(Selector("toString")).takeUnretainedValue() as? String else { fatalError() }
            DispatchQueue.main.async {
                self.textView.text = self.textView.text.appending(string).appending("\n")
            }
        } as @convention(block) (NSObject?, NSObject?) -> Void, forKey: "exceptionHandler")
        
        self.prompt.delegate = self
        let stackView = UIStackView(arrangedSubviews: [self.textView, self.prompt])
        stackView.axis = .vertical
        self.view = stackView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let script = textField.text else { fatalError() }
        
        DispatchQueue.main.async {
            self.textView.text = self.textView.text.appending("> \(script)").appending("\n")
            self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text?.count ?? 0, 0))
        }
        
        textField.text?.removeAll()
        let jsValue = self.context.perform(Selector("evaluateScript:"), with: script).takeUnretainedValue()
        guard let result = jsValue.perform(Selector("toString")).takeRetainedValue() as? String else { fatalError() }
        
        DispatchQueue.main.async {
            self.textView.text = self.textView.text.appending(result).appending("\n")
            self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text?.count ?? 0, 0))
        }
        
        return false
    }
}

PlaygroundPage.current.liveView = ViewController()
