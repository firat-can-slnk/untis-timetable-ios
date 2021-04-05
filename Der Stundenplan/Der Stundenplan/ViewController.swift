//
//  ViewController.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 24.01.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

/******************************************************
    Prototype Cell
 *******************************************************/
class SchoolCell: UITableViewCell {
    @IBOutlet weak var SchulnameLabel: UILabel!
    @IBOutlet weak var AdresseLabel: UILabel!
    
}
// ViewController in dem man die Schule auswählt
class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    /******************************************************
        Suchfeld
     *******************************************************/
    
    // Textfeld (Suche) zurodnen
    @IBOutlet weak var SchoolSearchText: UITextField!
    
    @IBAction func SchoolSearch(_ sender: Any) { // Buchstaben eingegeben/gelöscht im Textfeld (Suche)
        // Suche nach Schule abbrechen
        stopTimerTest()
        
        // Suche nach Schule starten
        startTimer()
    }
    @IBAction func SchoolSearchPrimaryAction(_ sender: Any) { // Wenn man in der Tastatur auch "Suchen" drückt
        // Nach Schulen suchen
        reloadSchools()
    }
    
    
    /******************************************************
        Table View
    *******************************************************/
    

    
    // TableView zuordnen
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a new cell with the reuse identifier of our prototype cell
        // as our custom table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolCell") as! SchoolCell
        
        cell.SchulnameLabel.text = tableData[indexPath.row].Schulname
        cell.AdresseLabel.text = tableData[indexPath.row].Adresse
        
        // Return our new cell for display
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.selectedLoginRow = indexPath.row
        Global.tableData = tableData
        stopTimerTest()
        
        // Wenn ausgewähltes Cell keine (Fehler)meldung ist
        if tableData[indexPath.row].Server != "too many results" && tableData[indexPath.row].Server != "-" {
            performSegue(withIdentifier: "GoToCredentials", sender: nil)
        }
        
    }
    
    /******************************************************
        Variablen
     *******************************************************/
    struct SchoolData {
        var Schulname: String
        var Adresse: String
        var Server: String
        var SchuleCode: String
    }
    var tableData: [SchoolData] = []
    
   
    
    /******************************************************
        viewDidLoad()
     *******************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
        hideKeyboardWhenTappedAround()
        tableData = []
        reloadSchools()
        
    }
    
    /******************************************************
        Timer
     *******************************************************/
    var timerTest: Timer? // Timer initialisieren

    func startTimer() {
        // Wenn Timer am laufen ist, nach (timeInterval) in Sek die Funktion in "selector" ausführen
        if timerTest == nil {
            timerTest =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadSchools), userInfo: nil, repeats: false)
        }
    }
    
    func stopTimerTest() {
        // Wenn ein Timer am laufen ist soll er sofort beendet werden
        if timerTest != nil {
            timerTest!.invalidate()
            timerTest = nil
        }
    }
    
    /******************************************************
        Table View aktualisieren
     *******************************************************/
    
    // Schule suchen mit eingabe vom Textfield und TableView aktualisieren
    @objc func reloadSchools() {
        print("reloading")
        let search:String = SchoolSearchText.text!
        
        tableData = [] // Aktuelle Daten zurücksetzen
        
        if getSchools(search: search) == false {// Schulen suchen mit Text der Variable "search"
            Global.SchoolsResponse = [NSLocalizedString("Error", comment: ""), NSLocalizedString("No internet connection", comment: ""), "too many results"]
        }
        print(Global.SchoolsResponse)
        
        let anzahlSchulen = Global.SchoolsResponse.count / 3 // Alle 3 Zeilen der Ausgabe sind eine Schule
        
        var x = 0 // Variable für die Anzahl der Schulen
        var i = 0 // Variable für die Schleife des Cells
        while anzahlSchulen > x { // Alle Schulen durchgehen
            
            var server = ""
            var school = ""
            
            if Global.SchoolsResponse[i+2].contains("//") {
                let fullServerAdress = Global.SchoolsResponse[i+2]
                let serverAndSchool = fullServerAdress.components(separatedBy: "=")
            
                
                let string = serverAndSchool[0]
                var matched = matches(for: "/(.*)/", in: string)
                var serverMatch = matched[0]
                serverMatch = String(serverMatch.dropFirst())
                serverMatch = String(serverMatch.dropFirst())
                serverMatch = String(serverMatch.dropLast())
                print(serverMatch)
                    
                server    = serverMatch
                if Global.SchoolsResponse[i+2].contains("="){
                school = serverAndSchool[1]
                }
            }
            
            
            
            
            
            // Text einfügen in Cell
            tableData.append(SchoolData(Schulname: Global.SchoolsResponse[i], Adresse: Global.SchoolsResponse[i+1], Server: server, SchuleCode: school))
            
            i += 3 // Pro Schule 4 Zeilen -> mit 3 Addieren damit: 0, 3, 6, 9, 12, ..
            x += 1
        }
        
        
        
        // Animation (fade 0.3sek)
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.3
        transition.subtype = CATransitionSubtype.fromTop
        tableViewOutlet.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        
        // TableView aktualisieren
        tableViewOutlet.reloadData()
    }
    
}


