import Foundation
import KleinKit

public protocol StateProvider {
    func map<B>(_ transform: @escaping (AppState) -> B) -> Signal<B>
    func map<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B>
    subscript<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B> { get }

    func subscribe(`if` condition: @escaping (AppState?, AppState) -> Bool,
                   _ handler: @escaping (AppState) -> Void) -> Disposable
    func subscribe(_ handler: @escaping (AppState) -> Void) -> Disposable
}
