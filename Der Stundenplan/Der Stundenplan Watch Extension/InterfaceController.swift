//
//  InterfaceController.swift
//  Der Stundenplan Watch Extension
//
//  Created by Firat Sülünkü on 05.04.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class CustomRowController: NSObject {
    @IBOutlet weak var FachLabel: WKInterfaceLabel!
    @IBOutlet weak var UhrzeitLabel: WKInterfaceLabel!
    @IBOutlet weak var LehrerLabel: WKInterfaceLabel!
    @IBOutlet weak var RaumLabel: WKInterfaceLabel!
    
}
class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        print(error ?? "ok") 
    }
    
    let session = WCSession.default
    
    override func didAppear() {
         processApplicationContext()
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        processApplicationContext()
        
        session.delegate = self
        session.activate()
    }
    
    func processApplicationContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : [[String]]] {
            print(iPhoneContext)
            tableData = iPhoneContext["info"] ?? [[NSLocalizedString("Please log in first.", comment: ""), "", "", ""]]
            loadTableData()
        }
    }
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async() {
            self.processApplicationContext()
        }
    }

    @IBOutlet weak var myTable: WKInterfaceTable!
    var tableData: [[String]] = [
        []
//                        ["EP", "8:00 - 9:30", "BÖC", "HNE303"],
//                        ["Ma", "9:45 - 11:15", "HIN", "HNE301"],
//                        ["De", "11:45 - 13:15", "BEE", "HNE101"],
//                        ["DIF-EP", "13:30 - 15:00", "SCA", "HNN109"]
                    ]
    

    @IBOutlet weak var DatumLabel: WKInterfaceLabel!
    
    
    struct Variablen {
        static var test: [[String]] = [[NSLocalizedString("Please log in first.", comment: ""), "", "", ""]]
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        processApplicationContext()
        let formattedDate: String = getFormattedDate(format: "E, dd. MMM yyyy", date: Date())

        DatumLabel.setText(formattedDate)
        loadTableData()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    private func loadTableData(){
        myTable.setNumberOfRows(tableData.count, withRowType: "CustomRowController")
        
        if tableData == [["", "", "", ""]] {
            tableData = [[NSLocalizedString("There is nothing for today.", comment: ""), "", "", ""]]
        }
        
        var i = 0;
        while i < tableData.count {
            let row = myTable.rowController(at: i) as! CustomRowController
            
            row.FachLabel.setText(tableData[i][0] as? String)
            row.UhrzeitLabel.setText(tableData[i][1] as? String)
            row.LehrerLabel.setText(tableData[i][2] as? String)
            row.RaumLabel.setText(tableData[i][3] as? String)
            
            if (tableData[i][0] as? String)!.isEmpty{
                row.FachLabel.setHidden(true)
            }else{
                row.FachLabel.setHidden(false)
            }
            if (tableData[i][1] as? String)!.isEmpty{
                row.UhrzeitLabel.setHidden(true)
            }else{
                row.UhrzeitLabel.setHidden(false)
            }
            if (tableData[i][2] as? String)!.isEmpty{
                row.LehrerLabel.setHidden(true)
            }else{
                row.LehrerLabel.setHidden(false)
            }
            if (tableData[i][3] as? String)!.isEmpty{
                row.RaumLabel.setHidden(true)
            }else{
                row.RaumLabel.setHidden(false)
            }
            
            i += 1
        }
        
    
    }
    func getFormattedDate(format: String, date: Date ) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    

}
