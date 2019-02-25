import Foundation
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc public protocol PersonJSExports : JSExport {
    var firstName: String { get set }
    var lastName: String { get set }
    var birthYear: NSNumber? { get set }
    
    var fullName: String { get }
    
    
    /// create and return a new Person instance with `firstName` and `lastName`
        static func createWith(firstName: String, lastName: String) -> Person
}

// Custom class must inherit from `NSObject`
@objc public class Person : NSObject, PersonJSExports {
    // properties must be declared as `dynamic`
    public dynamic var firstName: String
    public dynamic var lastName: String
    public dynamic var birthYear: NSNumber?
    
    public required init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    public class func createWith(firstName: String, lastName: String) -> Person {
            return Person(firstName: firstName, lastName: lastName)
        }
    
//    public func getFullName() -> String {
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
