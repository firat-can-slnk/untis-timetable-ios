//
//  GlobalVariables.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 13.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import JZCalendarWeekView

struct Global {
    static var domain: String = "https://example.com"
    static var clientName: String = "ClientName"
    static var SchoolsResponse: [String] = ["a"]
    static var selectedLoginRow: Int = 0 // Selected Row in Login Table View
    /*
     Global.tableData[x].Schulname = Heinz-Nixdorf-BK
                        .Adresse = 45144 Essen, Dahnstrasse 50
                        .Server = https://mese.webuntis.com/WebUntis?school=Nixdorf_BK_Essen

     */
    static var tableData: [LoginViewController.SchoolData] = []
    
    struct LoginCredentialsStructure {
         var Server: String
         var Schule: String
         var Benutzername: String
         var Passwort: String
        var SchuleCode: String
    }
    static var LoginCredentials: Global.LoginCredentialsStructure =
        Global.LoginCredentialsStructure(Server: "", Schule: "", Benutzername: "", Passwort: "", SchuleCode: "");
    
    static var DefaultEvent:[DefaultEvent] = []
    
    static var i: Int = 0
    
    static var loadedDates: [String] = []
    static var selectedEvent: DefaultEvent = Global.DefaultEvent[0]
}
