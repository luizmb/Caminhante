import Foundation
import KleinKit

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<ActionRequestType: ActionRequest>(_ action: ActionRequestType)
}
