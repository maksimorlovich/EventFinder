//
//  AppDelegate.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/2/19.
//

import UIKit
import PromiseKit
import SeatGeekService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let userId: UserID = "guest"
    var mainCoordinator: MainCoordinator!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        // App services
        let documentsFolder =
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let favoritesDBPath = documentsFolder + "/favorites.sqlite3"
        // swiftlint:disable:next force_try
        let favoriteService = try! SeatGeekFavoriteServiceSQL(filepath: favoritesDBPath)
        let eventService = SeatGeekEventServiceLive(clientId: "MTQyNTcxNjN8MTU0NDA2NTkyNi42")
        let imageManager = ImageManager()
        
        self.mainCoordinator = MainCoordinator(
            eventService: eventService, favoriteService: favoriteService,
            imageManager: imageManager, userId: self.userId)
        self.mainCoordinator.anyRouter.setRoot(for: self.window!)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming
        // phone call or SMS message) or when the user quits the application and it begins
        // the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics
        // rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to
        // its current state in case it is terminated later.
        // If your application supports background execution, this method is called
        // instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application
        // was inactive. If the application was previously in the background, optionally
        // refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }
}
