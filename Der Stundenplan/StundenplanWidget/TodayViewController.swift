//
//  TodayViewController.swift
//  StundenplanWidget
//
//  Created by Firat Sülünkü on 12.04.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation



class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var StartLabel: UILabel!
    @IBOutlet weak var EndLabel: UILabel!
    @IBOutlet weak var FachLabel: UILabel!
    @IBOutlet weak var LehrerLabel: UILabel!
    @IBOutlet weak var RaumLabel: UILabel!
    @IBOutlet weak var myView: UIView!
    
}

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    func getFormattedDate(format: String, date: Date ) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.regionCode ?? "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            let height = 27 + 69 * Variablen.test.count
            preferredContentSize = CGSize(width: 0, height: height)
        } else {
            preferredContentSize = maxSize
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
//    let test = [
//        ["Englisch", "09:00", "10:00", "ALS", "HN12"],
//        ["Mathe", "10:30", "11:00", "LAS", "HN72"],
//        ["Deutsch", "12:00", "12:30", "LOP", "HN33"]
//                ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Variablen.test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! CustomTableViewCell
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.clear
        }
        else{
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
        }
        
        if Variablen.test == [["","","","", ""]] {
            
            cell.FachLabel.text = NSLocalizedString("There is nothing for today.", comment: "")
            cell.StartLabel.text =  nil
            cell.EndLabel.text = nil
            cell.LehrerLabel.text = nil
            cell.RaumLabel.text = nil
        }else{
            
            cell.FachLabel.text = Variablen.test[indexPath.row][0]
            cell.StartLabel.text = Variablen.test[indexPath.row][1]
            cell.EndLabel.text = Variablen.test[indexPath.row][2]
            cell.LehrerLabel.text = Variablen.test[indexPath.row][3]
            cell.RaumLabel.text = Variablen.test[indexPath.row][4]
        }
        
        
        cell.myView.layer.cornerRadius = 3;
        
        return cell
        
        
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshImage: UIImageView!
    
    @IBAction func refreshAction(_ sender: Any) {
        
        print("refreshing")
        
        let temp = Variablen.test

        UIView.animate(withDuration: 0.5) { () -> Void in
            self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            Variablen.test = [["Loading..","","","", ""]]
            self.myTableView.reloadData()
        }
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            Variablen.test = temp
            self.myTableView.reloadData()
        }
        
        
        print("refreshed")
        
    }
    
    struct Variablen {
    static var test: [[String]] = [[NSLocalizedString("Please log in first.", comment: ""), "", "", "", ""]]
    }
        
    @IBOutlet weak var DatumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let appGroupID = "group.StundenplanHI-17C"
        
        let defaults = UserDefaults(suiteName: appGroupID)
        
        Variablen.test = defaults?.object(forKey: "StundenplanWidget") as? [[String]] ?? [[NSLocalizedString("Please log in first.", comment: ""), "", "", "", ""]]
        print(Variablen.test)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        DatumLabel.text = getFormattedDate(format: "EEEE, dd. MMMM. yyyy", date: Date())
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var myTableView: UITableView!
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        myTableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }
    
}


