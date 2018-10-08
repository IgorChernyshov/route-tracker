//
//  AppDelegate.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 19.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications

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
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      guard granted else {
        print("Permission wasn't granted")
        return
      }
    }
    
    return true
  }
  
  func makeNotificationContent() -> UNNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = "Please return to us"
    content.body = "Lots of cool things happened while you were away"
    content.badge = 1
    return content
  }
  
  func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
    return UNTimeIntervalNotificationTrigger(
      timeInterval: 10,
      repeats: false
    )
  }
  
  func sendNotificationRequest(
    content: UNNotificationContent,
    trigger: UNNotificationTrigger) {
    
    let request = UNNotificationRequest(
      identifier: "returnRequest",
      content: content,
      trigger: trigger
    )
    
    let center = UNUserNotificationCenter.current()
    center.add(request) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Create a blurry view for safety
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
    let blurredView = UIVisualEffectView(effect: blurEffect)
    blurredView.frame = window!.frame
    blurredView.tag = 105
    
    self.window?.addSubview(blurredView)
    )
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Setup a user notification to fire after 10 sec
    self.sendNotificationRequest(
      content: self.makeNotificationContent(),
      trigger: self.makeIntervalNotificationTrigger()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    self.window?.viewWithTag(105)?.removeFromSuperview()
    application.applicationIconBadgeNumber = 0
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

