//
//  AppDelegate.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkReachability()
        if (UserManager.shared.userDidFirstLaunch() ?? false) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "News", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    private func checkReachability(){
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
    }
}

