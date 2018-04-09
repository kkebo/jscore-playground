import UIKit
import PlaygroundSupport

Bundle(path: "/System/Library/Frameworks/JavaScriptCore.framework")?.load()
let JSContextClass = NSClassFromString("JSContext") as? NSObject.Type

struct Log {
    enum LogType {
        case input
        case value
        case error
    }
    public let text: String
    public let type: LogType
}

class ViewController: UIViewController {
    var context: NSObject = {
        guard let instance = JSContextClass?.init() as? NSObject else { fatalError() }
        return instance
    }()
    private var results: [Log] = [];
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
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
            self.appendCell("❌ \(string)", type: .error)
        } as @convention(block) (NSObject?, NSObject?) -> Void, forKey: "exceptionHandler")
        
        self.prompt.delegate = self
        
        self.tableView.dataSource = self
        
        let stackView = UIStackView(arrangedSubviews: [self.tableView, self.prompt])
        stackView.axis = .vertical
        self.view = stackView
    }
    
    func appendCell(_ text: String, type: Log.LogType) {
        let log = Log(text: text, type: type)
        self.results.append(log)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.results.count - 1, section: 0), at: .top, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let script = textField.text else { fatalError() }
        
        self.appendCell("> \(script)", type: .input)
        
        textField.text?.removeAll()
        let jsValue = self.context.perform(Selector("evaluateScript:"), with: script).takeUnretainedValue()
        guard let result = jsValue.perform(Selector("toString")).takeRetainedValue() as? String else { fatalError() }
        
        self.appendCell("< \(result)", type: .value)
        
        return false
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.results[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch item.type {
        case .input:
            cell.textLabel?.textColor = #colorLiteral(red: 0.176470592617989, green: 0.498039215803146, blue: 0.756862759590149, alpha: 1.0)
        case .error:
            cell.backgroundColor = #colorLiteral(red: 0.95686274766922, green: 0.658823549747467, blue: 0.545098066329956, alpha: 1.0)
        default:
            break
        }
        cell.textLabel?.font = UIFont(name: "Menlo", size: 14)
        cell.textLabel?.text = item.text
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
}

PlaygroundPage.current.liveView = ViewController()
