//
//  AppDelegate.swift
//  Todoey
//
//  Created by Gabriel Del VIllar on 11/3/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    do{
      _ = try Realm()
    } catch {
      print("Error initialising new realm, \(error)")
    }
    
   
    
    return true
  }
}

