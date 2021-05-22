import Foundation

protocol EditorModeSwitcher: AnyObject {
    func switchToCommandMode()
    func switchToInsertMode(freeTextCommand: FreeTextOperation)
    func switchToVisualMode(selection: VimSelection?)

    /// Ensure key is up when switching to insert mode to prevent a single key up event to be passed through
    func onKeyUp(_ block: @escaping () -> Void)
}
