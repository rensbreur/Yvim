import Foundation

protocol EditorMode: KeyHandler {
    var mode: Mode { get }
}
