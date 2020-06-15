import Foundation

let JSContextClass = { () -> NSObject.Type in
    Bundle(path: "/System/Library/Frameworks/JavaScriptCore.framework")!.load()
    return NSClassFromString("JSContext") as! NSObject.Type
}()

public final class JSValue {
    let rawValue: AnyObject

    init(from jsValue: AnyObject) {
        self.rawValue = jsValue
    }

    public func toString() -> String {
        self.rawValue.perform(Selector("toString")).takeUnretainedValue() as! String
    }

    public func objectForKeyedSubscript(_ key: Any) -> JSValue {
        JSValue(from: self.rawValue.perform("objectForKeyedSubscript:", with: key).takeUnretainedValue())
    }

    public func setObject(_ object: Any, forKeyedSubscript key: Any) {
        self.rawValue.perform(Selector("setObject:forKeyedSubscript:"), with: object, with: key)
    }
}

public final class JSContext {
    let rawContext: NSObject
    public var exceptionHandler: ((JSContext?, JSValue?) -> Void)? {
        didSet {
            self.rawContext.setValue({ (context: NSObject!, exception: NSObject!) in
                self.exceptionHandler?(JSContext(from: context!), JSValue(from: exception))
            } as @convention(block) (NSObject?, NSObject?) -> Void, forKey: "exceptionHandler")
        }
    }

    public init() {
        self.rawContext = JSContextClass.init() as! NSObject
    }

    init(from context: NSObject) {
        self.rawContext = context
    }

    public func evaluateScript(_ script: String) -> JSValue {
        JSValue(from: self.rawContext.perform(Selector("evaluateScript:"), with: script).takeUnretainedValue())
    }

    public func objectForKeyedSubscript(_ key: Any) -> JSValue {
        JSValue(from: self.rawContext.perform("objectForKeyedSubscript:", with: key).takeUnretainedValue())
    }

    public func setObject(_ object: Any, forKeyedSubscript key: NSCopying & NSObjectProtocol) {
        self.rawContext.perform(Selector("setObject:forKeyedSubscript:"), with: object, with: key)
    }
}
