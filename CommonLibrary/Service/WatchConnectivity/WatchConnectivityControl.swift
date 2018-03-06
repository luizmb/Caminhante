//
//  WatchConnectivity.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 06.03.18.
//

import Foundation
import HealthKit
import KleinKit
import WatchConnectivity

public class WatchConnectivityControl: NSObject, RemoteDevice {
    public var disposables: [Any] = []
    var session: WCSession?

    public static let shared: RemoteDevice = {
        let global = WatchConnectivityControl()
        return global
    }()

    override private init() {
        super.init()
    }

    public func activateSession() {
        guard WCSession.isSupported() else {
            // iPad or no watch paired...
            return
        }

        #if os(watchOS)
            stateProvider[\.currentActivity]
                .subscribe(if: { oldActivity, newActivity in
                    switch (oldActivity?.flatMap { $0 }, newActivity) {
                    case (.none, .some), (.some, .none):
                        return true
                    case (.some(let oldState), .some(let newState)):
                        return oldState.state != newState.state
                    default:
                        return false
                    }
                }, { [weak self] activity in
                    self?.updateState(type: ActivityState.className,
                                      data: [ActivityState.className: activity?.state])
                })
                .bind(to: self)
        #endif

        if session == nil {
            session = WCSession.default
            session!.delegate = self
            session!.activate()
        }
    }

    public func updateState<T: Codable>(type: String, data: T) {
        #if os(iOS)
        guard session?.isWatchAppInstalled ?? false else { return }
        #endif

        guard let data = try? JSONEncoder().encode(data) else { return }
        try? session!.updateApplicationContext([type: data])
    }

    public func send<T: Codable>(type: String, data: T) {
        #if os(iOS)
        guard session?.isWatchAppInstalled ?? false else { return }
        #endif

        guard let data = try? JSONEncoder().encode(data) else { return }
        session!.transferUserInfo([type: data])
    }

    public enum SendMessageError: Error {
        case appNotInstalledOnWatch
        case encodingJson
    }

    public func send<T: Codable>(type: String, data: T, completion: @escaping (Result<Void>) -> Void) {
        #if os(iOS)
        guard session?.isWatchAppInstalled ?? false else {
            completion(.failure(SendMessageError.appNotInstalledOnWatch))
            return
        }
        #endif

        guard let data = try? JSONEncoder().encode(data) else {
            completion(.failure(SendMessageError.encodingJson))
            return
        }

        session!.sendMessage([type: data],
                             replyHandler: { _ in completion(.success(())) },
                             errorHandler: { completion(.failure($0)) })
    }
}

extension WatchConnectivityControl: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.actionDispatcher.dispatch(RemoteDeviceAction.activationComplete(success: activationState == .activated))
        }
    }

    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        DispatchQueue.main.async {
            self.actionDispatcher.async(RemoteDeviceActionRequest.handleUpdatedState(applicationContext))
        }
    }

    public func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        DispatchQueue.main.async {
            self.actionDispatcher.async(RemoteDeviceActionRequest.handleData(userInfo))
        }
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        DispatchQueue.main.async {
            self.actionDispatcher.async(RemoteDeviceActionRequest.handleDataWithCompletion(message, completion: replyHandler))
        }
    }

    #if os(iOS)
    public func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.actionDispatcher.dispatch(RemoteDeviceAction.reachabilityChanged(isReachable: session.isReachable))
        }
    }

    public func sessionDidBecomeInactive(_ session: WCSession) {
    }

    public func sessionDidDeactivate(_ session: WCSession) {
    }
    #endif
}

extension WatchConnectivityControl: HasStateProvider { }
extension WatchConnectivityControl: HasActionDispatcher { }
extension WatchConnectivityControl: HasDisposableBag { }
