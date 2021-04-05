//
//  CalendarView.swift
//  
//
//  Created by Firat Sülünkü on 21.03.19.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import JZCalendarWeekView
import SwiftDate
import WatchConnectivity

class InfoCell: UITableViewCell {
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ImageOfRow: UIImageView!
    
}


class FachPreview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        
        cell.TitleLabel.text = event[indexPath.row].1
        cell.ImageOfRow.image = event[indexPath.row].0
        
        
        return cell
    }
    
    var event: [(UIImage, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Global.selectedEvent.title

        if !Global.selectedEvent.title.isEmpty {
            event.append((#imageLiteral(resourceName: "book@3x.png"), Global.selectedEvent.title))
        }
        if Global.selectedEvent.startDate != nil || Global.selectedEvent.endDate != nil {
            event.append((#imageLiteral(resourceName: "timer@3x.png"), getFormattedDate(format: "E, dd. MMM yyyy, H:mm - ", date: Global.selectedEvent.startDate) + getFormattedDate(format: "H:mm", date: Global.selectedEvent.endDate)))
        }
        if !Global.selectedEvent.teacher.isEmpty {
            
            event.append((#imageLiteral(resourceName: "user_group_man_woman@3x.png"), Global.selectedEvent.teacher))
        }
        if !Global.selectedEvent.location.isEmpty {
            
            event.append((#imageLiteral(resourceName: "icons8-zimmer-filled-100.png"), Global.selectedEvent.location))
        }
        

        
        
    }
}

class CalendarView: UIViewController, UITabBarDelegate, UIViewControllerPreviewingDelegate, WCSessionDelegate  {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
       
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
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
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        //let calendarCollectionView = calendarWeekView.collectionView
        
        let offsetPoint = self.calendarWeekView.collectionView.contentOffset
        let realLocation = CGPoint(x: location.x + offsetPoint.x, y: location.y + offsetPoint.y)

            
        
            
        if let indexPath = self.calendarWeekView.collectionView.indexPathForItem(at: realLocation){
            
            print("Section: \(indexPath.section) Row: \(indexPath.row)")
        
            Global.selectedEvent = calendarWeekView.getCurrentEvent(with: indexPath) as! DefaultEvent
            
            
            let preview = storyboard?.instantiateViewController(withIdentifier: "FachPreviewID")
            return preview
        }
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let finalVC = storyboard?.instantiateViewController(withIdentifier: "FachPreviewID")
        show(finalVC!, sender: self)
    }
    

    @IBOutlet weak var myTabBarItem: UITabBarItem!
    
    
    
    @IBAction func Logout(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "LoginPasswort")
        performSegue(withIdentifier: "Logout", sender: self)
    }
    
    
    @IBOutlet weak var calendarWeekView: JZBaseWeekView!
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calendarWeekView.scrollWeekView(to: Date().dateAt(.startOfWeek) + 7.hours)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
        
        
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        
        
        //3D touch
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: calendarWeekView)
        }
        
        calendarWeekView.baseDelegate = self
        Global.DefaultEvent = []
        
        print(getFormattedDate(format: "yyyy-MM-dd HH:ii", date: Date()))
        lastUpdateTimeLabel.text = getFormattedDate(format: "yyyy-MM-dd HH:mm", date: Date())
        let _ = addEventsFromJson(url:
                        getURLWithDate(date:
                            getFormattedDate(format: "yyyy-MM-dd",
                                             date: Date().dateAt(.startOfWeek) + 1.days
                                            )
                                        )
                                    )
        
        
        calendarWeekView.setupCalendar(numOfDays: 6,
                                       setDate: Date().dateAt(.startOfWeek),
                                       allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: Global.DefaultEvent),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       currentTimelineType: .section,
                                       visibleTime: Date().set(hour: 6))
        
        
        
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourHeight: 75, rowHeaderWidth: 50, columnHeaderHeight: 50, hourGridDivision: JZHourGridDivision.minutes_15))

        
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
        
        sendMessage(events: sortedEvents)
        defaults?.set(sortedEvents2, forKey: "StundenplanWidget")
        
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }

    
}






extension CalendarView: JZBaseViewDelegate {
    

    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        
            let currentDateDisplayed = initDate + 1.weeks // +1 Week -> initDate is -1Week
            
        
        
            let success = addEventsFromJson(url:
                                            getURLWithDate(date:
                                                getFormattedDate(format: "yyyy-MM-dd", date: currentDateDisplayed)
                                                )
                                            )
        
            // If it works to get the Data
            if (success){
                print("OKAY")
            
            calendarWeekView.allEventsBySection = JZWeekViewHelper.getIntraEventsByDate(originalEvents: Global.DefaultEvent)
            
            calendarWeekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: Global.DefaultEvent))
            
                

                
            }
            
        
    }
}


class baseWeekView: JZBaseWeekView {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = getCurrentEvent(with: indexPath) as! DefaultEvent
        print(selectedEvent.title)
    }

    override func registerViewClasses() {
        super.registerViewClasses()
        
        // Register CollectionViewCell
        self.collectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as! EventCell
        cell.configureCell(event: getCurrentEvent(with: indexPath) as! DefaultEvent)
        return cell
    }
    
}
