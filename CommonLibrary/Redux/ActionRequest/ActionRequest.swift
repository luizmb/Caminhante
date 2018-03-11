import Foundation
import KleinKit

public protocol ActionRequest: ActionAsync where StateType == AppState {
}
