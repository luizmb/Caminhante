//
//  AppDelegate.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import CommonLibrary
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        actionDispatcher.async(BootstrapActionRequest.boot(application))
        return true
    }
}

extension AppDelegate: HasActionDispatcher { }