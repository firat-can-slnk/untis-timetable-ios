//
//  AppDelegate.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 24.01.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import WatchConnectivity
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectivityHandler : ConnectivityHandler?

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        application.setMinimumBackgroundFetchInterval(1200)
        print("Background Fetch")
        let defaults1 = UserDefaults.standard
        
        if ((KeychainWrapper.standard.string(forKey: "LoginPasswort")) != nil && defaults1.object(forKey: "Server") != nil && !(defaults1.string(forKey: "Server")?.isEmpty)!){
            
            var session: WCSession?
            
            
            var connectivityHandler : ConnectivityHandler!
            var counter = 0
            
            func sendMessage(events: [[String]]) {
                print("Sending MSG")
                if let validSession = session {
                    
                    var sortedEvents = events
                    sortedEvents.sort{ ($0[1]) < ($1[1]) }
                    
                    let iPhoneAppContext : [String : [[String]]] = ["info":sortedEvents]
                    
                    
                    
                    do {
                        try validSession.updateApplicationContext(iPhoneAppContext)
                        print("Msg sent")
                    } catch {
                        print("Something went wrong")
                    }
                }else{
                    print("Error while sending msg")
                }
            }
            
            
            let _ = addEventsFromJson(url:
                getURLWithDate(date:
                    getFormattedDate(format: "yyyy-MM-dd",
                                     date: Date().dateAt(.startOfWeek) + 1.days
                    )
                    , ignoreLoadedDates: true)
            )
            
            // today2Events = WatchApp
            var todaysEvents: [[String]] = [["","","",""]]
            // todaysEvents2 = Widget
            var todaysEvents2: [[String]] = [["","","","", ""]]
            
            Global.DefaultEvent = Array(Set(Global.DefaultEvent))
            
            for item in Global.DefaultEvent{
                // Wenn item heute ist
                if item.startDate.isToday {
                    print(item)
                    if todaysEvents == [["","","",""]] { // Initialisierung entfernen
                        todaysEvents.removeAll()
                    }
                    
                    // Zwei Zeiten in ein String packen "09:00" & "11:00" -> "09:00 - 11:00"
                    var customDate:String = getFormattedDate(format: "HH:mm", date: item.startDate)
                    customDate = customDate + " - " + getFormattedDate(format: "HH:mm", date: item.endDate)
                    // Event hinzufügen
                    todaysEvents.append([item.title, customDate, item.teacher, item.location])
                    
                    //                ------
                    if todaysEvents2 == [["","","","",""]] { // Initialisierung entfernen
                        todaysEvents2.removeAll()
                    }
                    // Event hinzufügen
                    todaysEvents2.append([item.title, getFormattedDate(format: "HH:mm", date: item.startDate), getFormattedDate(format: "HH:mm", date: item.endDate), item.teacher, item.location])
                    
                }
                
            }
            todaysEvents = Array(Set(todaysEvents))
            todaysEvents2 = Array(Set(todaysEvents2))
            // WatchApp sortieren
            var sortedEvents = todaysEvents
            sortedEvents.sort{ ($0[1]) < ($1[1]) }
            // Widget sortieren
            var sortedEvents2 = todaysEvents2
            sortedEvents2.sort{ ($0[1]) < ($1[1]) }
            
            let appGroupID = "group.StundenplanHI-17C"
            
            let defaults = UserDefaults(suiteName: appGroupID)
            
            print(sortedEvents2)
            
            defaults?.set(sortedEvents2, forKey: "StundenplanWidget")
            sendMessage(events: sortedEvents)
            
            
            
        }
        
        

        
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        // Override point for customization after application launch.
         let defaults1 = UserDefaults.standard
        if(defaults1.string(forKey: "Server")?.isEmpty ?? true || (KeychainWrapper.standard.string(forKey: "LoginPasswort")) == nil){
            print("Not Logged In")
            
            
            
            
            
            
            
        }else if ((KeychainWrapper.standard.string(forKey: "LoginPasswort")) != nil && defaults1.object(forKey: "Server") != nil && !(defaults1.string(forKey: "Server")?.isEmpty)!){
            print("Logged In")
            
            
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = self
                session.activate()
                
            }
            
            var session: WCSession?
            
            
            var connectivityHandler : ConnectivityHandler!
            var counter = 0
            
            func sendMessage(events: [[String]]) {
                print("Sending MSG")
                if let validSession = session {
                    
                    var sortedEvents = events
                    sortedEvents.sort{ ($0[1]) < ($1[1]) }
                    
                    let iPhoneAppContext : [String : [[String]]] = ["info":sortedEvents]
                    
                    
                    
                    do {
                        try validSession.updateApplicationContext(iPhoneAppContext)
                        print("Msg sent")
                    } catch {
                        print("Something went wrong")
                    }
                }else{
                    print("Error while sending msg")
                }
            }
            
            
            let _ = addEventsFromJson(url:
                getURLWithDate(date:
                    getFormattedDate(format: "yyyy-MM-dd",
                                     date: Date().dateAt(.startOfWeek) + 1.days
                    )
                    , ignoreLoadedDates: true)
            )
            
            // today2Events = WatchApp
            var todaysEvents: [[String]] = [["","","",""]]
            // todaysEvents2 = Widget
            var todaysEvents2: [[String]] = [["","","","", ""]]
            
            Global.DefaultEvent = Array(Set(Global.DefaultEvent))
            
            for item in Global.DefaultEvent{
                // Wenn item heute ist
                if item.startDate.isToday {
                    print(item)
                    if todaysEvents == [["","","",""]] { // Initialisierung entfernen
                        todaysEvents.removeAll()
                    }
                    
                    // Zwei Zeiten in ein String packen "09:00" & "11:00" -> "09:00 - 11:00"
                    var customDate:String = getFormattedDate(format: "HH:mm", date: item.startDate)
                    customDate = customDate + " - " + getFormattedDate(format: "HH:mm", date: item.endDate)
                    // Event hinzufügen
                    todaysEvents.append([item.title, customDate, item.teacher, item.location])
                    
                    //                ------
                    if todaysEvents2 == [["","","","",""]] { // Initialisierung entfernen
                        todaysEvents2.removeAll()
                    }
                    // Event hinzufügen
                    todaysEvents2.append([item.title, getFormattedDate(format: "HH:mm", date: item.startDate), getFormattedDate(format: "HH:mm", date: item.endDate), item.teacher, item.location])
                    
                }
                
            }
            todaysEvents = Array(Set(todaysEvents))
            todaysEvents2 = Array(Set(todaysEvents2))
            // WatchApp sortieren
            var sortedEvents = todaysEvents
            sortedEvents.sort{ ($0[1]) < ($1[1]) }
            // Widget sortieren
            var sortedEvents2 = todaysEvents2
            sortedEvents2.sort{ ($0[1]) < ($1[1]) }
            
            let appGroupID = "group.StundenplanHI-17C"
            
            let defaults = UserDefaults(suiteName: appGroupID)
            
            print(sortedEvents2)
            sendMessage(events: sortedEvents)
            defaults?.set(sortedEvents2, forKey: "StundenplanWidget")
            
            
            
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
        }
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}
extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message received: ",message)
    }
    
    //below 3 functions are needed to be able to connect to several Watches
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
}
