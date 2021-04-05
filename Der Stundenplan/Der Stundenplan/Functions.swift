//
//  Functions.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 13.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import SwiftKeychainWrapper

func getFormattedDate(format: String, date: Date ) -> String{
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: Locale.current.regionCode ?? "en")
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func addEventsFromJson(url: String) -> Bool {
    if url != "error" {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        
        let jsonString = getWebsiteContent(url: url)
        
        if(jsonString == "[{\"subject\":\"\",\"dtstart\":\"\",\"dtend\":\"\",\"room\":\"\",\"teacher\":\"\"}]"){
            print("FREI")
        }else{
            
            
            
            let json: AnyObject? = jsonString.parseJSONString
            
            
            var i = 0
            
            
            if json == nil {
                return false
            }else
                if (json!.count == nil){ // Keine Daten empfangen (vllt down?)
                    return false
                }else{
                    
                    
                    
                    while i < json!.count {
                        
                        let json = json![i] as AnyObject
                        
                        let title = json["subject"] as! String
                        let startDate = formatter.date(from: json["dtstart"] as! String)
                        let endDate = formatter.date(from: json["dtend"] as! String)
                        let location = json["room"] as! String
                        //let color = UIColor.init(red: 0, green: 128/255, blue: 255/255, alpha: 0.85)
                        let teacher = json["teacher"] as! String
                        
                        
                        let id:String = title + (startDate?.toString())! + (endDate?.toString())! + location + teacher
                        
                        
                        
                        Global.DefaultEvent.append(DefaultEvent(id: id, title: title, startDate: startDate!, endDate: endDate!, location: location, teacher: teacher))
                        
                        
                        
                        
                        
                        
                        i = i + 1
                    }
            }
        }
        return true
    }else{
        return false
    }
}

func getURLWithDate(date: String, ignoreLoadedDates: Bool = false) -> String {
    print(Global.loadedDates)
    if(Global.loadedDates.contains(date) && ignoreLoadedDates == false){
        return "error"
    }else{
        
        if (ignoreLoadedDates == false) {
            Global.loadedDates.append(date)
        }
        

        
        let defaults = UserDefaults.standard
        
        if ((KeychainWrapper.standard.string(forKey: "LoginPasswort")) != nil && !(defaults.string(forKey: "Server")?.isEmpty)!){
            
            let server = defaults.string(forKey: "Server")!
            let school = defaults.string(forKey: "SchuleCode")!
            let username = defaults.string(forKey: "Benutzername")!
            let password = KeychainWrapper.standard.string(forKey: "LoginPasswort")!
            let client = Global.clientName
            let id = "loggedin"
            
            let date = date
            var url = Global.domain + "/untis2/?server=" + server
            url = url + "&school=" + school
            url = url + "&jsonParamsUser=" + username
            url = url + "&jsonParamsPassword=" + password
            url = url + "&jsonParamsClient=" + client
            url = url + "&jsonID=" + id
            url = url + "&jsonMethod=authenticate&date=" + date;
            return url
        }
        
    }
    return "error"
}

public func swipedToNextPage(days: Int){
    
}
func getSchools(search: String) -> Bool {
    
    let escapedAddress = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    let locale:String = Locale.current.languageCode ?? "en"
    let domain      = Global.domain
    let myURLString = domain + "/untisAPI/getSchool.php?locale=" + locale + "&search=" + escapedAddress!
    
    print(myURLString)
    
    guard let myURL = URL(string:myURLString) else {
        print("Error: \(myURLString) doesn't seem to be a valid URL")
        return false
    }
    
    do {
        let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
        
        let myHTMLString1 = myHTMLString.components(separatedBy: "\n")
        
        
        
        Global.SchoolsResponse = myHTMLString1
        return true
    } catch let error {
        print("Error: \(error)")
        return false
    }
    

}
func getWebsiteContent(url: String, escaped: Bool = false, contentAfterSlashIfEscaped: String = "") -> String{
    
    var finalUrl: String = ""
    // If escaped = true -> split url to url=domain & contentAfterSlashIfEscaped=Parameters
    if (escaped == true) {
        let contentAfterSlashIfEscaped: String = contentAfterSlashIfEscaped.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
         finalUrl = url + contentAfterSlashIfEscaped
    }else{
         finalUrl = url
    }
    
    let myURLString = finalUrl
    
    guard let myURL = URL(string: myURLString) else {
        return "Error: \(myURLString) doesn't seem to be a valid URL"
        
    }
    
    do {
        let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
        return myHTMLString
        
    } catch let error {
        return "Error: \(error)"
    }
}
func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

