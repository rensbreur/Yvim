import Foundation

protocol Command {
    func perform(editor: VimEditor)
}

enum Commands {
    struct Delete: Command {
        func perform(editor: VimEditor) {
            editor.delete()
        }
    }

    struct Yank: Command {
        func perform(editor: VimEditor) {
            editor.yank()
        }
    }

    struct Paste: Command {
        func perform(editor: VimEditor) {
            editor.paste()
        }
    }
}
