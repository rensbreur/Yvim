import Foundation

protocol EditorModeSwitcher: AnyObject {
    func switchToCommandMode()
    func switchToInsertMode(freeTextCommand: FreeTextCommand)
    func switchToVisualMode(selection: VimSelection?)

    /// Ensure key is up when switching to insert mode to prevent a single key up event to be passed through
    func onKeyUp(_ block: @escaping () -> Void)
}
