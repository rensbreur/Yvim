import Cocoa
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var mainEditor: MainEditor!

    var keyboardEventTap: EventTap!
    var accessibilityService: AccessibilityService!
    var statusItemController: StatusItemController!
    var bufferEditor: AXBufferEditor!

    var activeCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {

        self.checkPermissions()
        self.accessibilityService = AccessibilityService()
        self.accessibilityService.start()
        self.bufferEditor = AXBufferEditor(accessibilitySvc: self.accessibilityService)
        self.mainEditor = MainEditor(editor: bufferEditor)
        self.statusItemController = StatusItemController()
        self.statusItemController.mode = self.mainEditor.$mode.eraseToAnyPublisher()
        self.statusItemController.active = self.accessibilityService.$active.eraseToAnyPublisher()
        self.statusItemController.start()
        self.activeCancellable = self.accessibilityService.$active.assign(to: \MainEditor.active, on: self.mainEditor)
        self.keyboardEventTap = EventTap()
        self.keyboardEventTap.eventHandler = KeyEventHandler(keyHandler: mainEditor)
        self.keyboardEventTap.startListening()
    }

    func checkPermissions() {
        let trustedCheckOptions = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let hasPermissions = AXIsProcessTrustedWithOptions(trustedCheckOptions as CFDictionary)
        if !hasPermissions {
            let alert = NSAlert()
            alert.messageText = "Restart Yvim after granting access."
            alert.runModal()
            exit(EXIT_FAILURE)
        }
    }
}
