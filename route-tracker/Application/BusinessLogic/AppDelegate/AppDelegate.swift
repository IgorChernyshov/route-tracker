//
//  AppDelegate.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 19.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    GMSServices.provideAPIKey("AIzaSyCDKMYs7o3NaT9unP90OH-xh1aLs_nhKYc")
    
    let controller: UIViewController
    if UserDefaults.standard.bool(forKey: "userIsLoggedIn") {
      controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MainMenuViewController.self)
    } else {
      controller = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(SignInViewController.self)
    }
    window = UIWindow()
    
    window?.rootViewController = UINavigationController(rootViewController: controller)
    
    window?.makeKeyAndVisible()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
    let blurredView = UIVisualEffectView(effect: blurEffect)
    blurredView.frame = window!.frame
    blurredView.tag = 105
    
    self.window?.addSubview(blurredView)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    self.window?.viewWithTag(105)?.removeFromSuperview()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

