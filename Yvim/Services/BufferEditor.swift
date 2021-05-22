import Foundation

protocol BufferEditor: AnyObject {
    func getText() -> NSString
    func getSelectedTextRange() -> CFRange
    func setSelectedTextRange(_ range: CFRange)
    func getSelectedText() -> NSString
    func setSelectedText(_ text: NSString)
}
