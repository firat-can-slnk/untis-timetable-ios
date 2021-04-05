//
//  SecondViewController.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 14.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
/*

import Foundation
import UIKit
import SwiftKeychainWrapper
import SwiftDate
import QVRWeekView


class SecondViewController: UIViewController, WeekViewDelegate {
    func didLongPressDayView(in weekView: WeekView, atDate date: Date) {
        
    }
    
    func didTapEvent(in weekView: WeekView, withId eventId: String) {
        print(eventId)
    }
    
    func eventLoadRequest(in weekView: WeekView, between startDate: Date, and endDate: Date) {
        
    }
    
    
    
    @IBOutlet weak var WeekView: WeekView!
    
//    @IBOutlet weak var Slider: UISlider!
//    @IBAction func SliderValueChanged(_ sender: Any) {
//        WeekView.currentZoomScale = CGFloat(Slider.value)
//    }
//    @IBOutlet weak var Slider2: UISlider!
//    @IBAction func Slider2ValueChanged(_ sender: Any) {
//        WeekView.visibleDaysInPortraitMode = Int(Slider2.value)
//
//    }
    
    func printSomething(){
        print("00000000")
    }
    
    

    


    override func viewDidLoad() {
        print(WeekView.visibleDayDateRange)
        super .viewDidLoad()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy"
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        let nextWeekDateString = dateFormatter.string(from: nextWeekDate)
        
        
//        addEventsFromJson(url: getURLWithDate(date: lastWeekDateString))
//        addEventsFromJson(url: getURLWithDate(date: "now"))
//        addEventsFromJson(url: getURLWithDate(date: nextWeekDateString))
        
            
        WeekView.loadEvents(withData: Global.Event)
        
        
        WeekView.visibleDaysInPortraitMode = 5
        WeekView.topBarColor = UIColor.white
        WeekView.currentZoomScale = 1.35
        WeekView.dayLabelShortDateFormat = "dd.MM"
        WeekView.dayLabelNormalDateFormat = "E, dd.MM"
        WeekView.dayLabelLongDateFormat = "E, dd MMMM"
        WeekView.hourLabelDateFormat = "HH"
        print(WeekView.dayViewDashedSeparatorPattern)
        
//        Slider.minimumValue = 0.5
//        Slider.maximumValue = 2.5
//        Slider.value = Float(WeekView.currentZoomScale)
//
//        Slider2.minimumValue = 1
//        Slider2.maximumValue = 7
//        Slider2.value = Float(WeekView.visibleDaysInPortraitMode)
//        print(Slider2.value)
//        print(Slider.value)
    }

}
 */
