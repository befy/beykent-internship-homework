//
//  AppDelegate.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = setupMainViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setupMainViewController() -> ScanViewController {
        let viewModel = ScanViewModel()
        return ScanViewController(viewModel: viewModel)
    }
    
    
}

