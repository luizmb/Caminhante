//
//  Store.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

final public class Store: StoreBase<AppState, EntryPointReducer>, ActionDispatcher, StateProvider {
    public static let shared: Store = {
        let global = Store()
        return global
    }()

    private init() {
        super.init(initialState: AppState(), reducer: EntryPointReducer())
    }

    // Workaround while waiting for 'SE-0143: Conditional Conformance'
    // https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md
    //extension Signal: StateProvider where A: AppState {
    //}
    // So we wrap the protocol, instead. And we use the Store itself to wrap it, instead
    // of introducing a new type.

    public func map<B>(_ transform: @escaping (AppState) -> B) -> Signal<B> {
        return stateSignal.map(transform)
    }

    public func map<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B> {
        return stateSignal.map(keyPath)
    }

    public subscript<B>(keyPath: KeyPath<AppState, B>) -> Signal<B> {
        return stateSignal[keyPath]
    }

    public func subscribe(if condition: @escaping (AppState?, AppState) -> Bool, _ handler: @escaping (AppState) -> Void) -> Disposable {
        return stateSignal.subscribe(if: condition, handler)
    }

    public func subscribe(_ handler: @escaping (AppState) -> Void) -> Disposable {
        return stateSignal.subscribe(handler)
    }
}
