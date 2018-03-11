import CommonLibrary
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    func applicationDidFinishLaunching() {
        actionDispatcher.async(BootstrapActionRequest.boot)
    }
}

extension ExtensionDelegate: HasActionDispatcher { }
