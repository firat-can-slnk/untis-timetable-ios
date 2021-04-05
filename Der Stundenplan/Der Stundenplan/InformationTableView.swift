//
//  InformationTableView.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 20.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit

class InformationTableView: UITableViewController {
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                UIApplication.shared.open(URL(string: "https://firatcan.de")!)
                break;
            case 1:
                UIApplication.shared.open(URL(string: "https://www.untis.at/")!)
                break;
                
            default: break;
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                
                let alert = UIAlertController(title: NSLocalizedString("How do I sign in?", comment: ""), message: NSLocalizedString("After you have chosen your school you have to login. You will receive your registration data from your school.", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                break;
            case 1:
                let alert = UIAlertController(title:NSLocalizedString("I forgot my password.", comment: "") , message: NSLocalizedString("You can change your password on the WebUntis page of your school.", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                break;
            case 2:
                let alert = UIAlertController(title: NSLocalizedString("Nothing is displayed.", comment: ""), message: NSLocalizedString("This may be because your user was not set up correctly or your school has not yet added lessons for the upcoming school year.", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil))
                
                self.present(alert, animated: true)
                break;
                
            default: break;
            }
        }
    }
    @IBOutlet var myTableView: UITableView!
}

class OpenSourceTableView: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            UIApplication.shared.open(URL(string: "https://github.com/zjfjack/JZCalendarWeekView/blob/master/LICENSE")!)
            break;
        case 1:
            UIApplication.shared.open(URL(string: "https://github.com/jrendel/SwiftKeychainWrapper/blob/develop/LICENSE")!)
            break;
        case 2:
            UIApplication.shared.open(URL(string: "https://github.com/malcommac/SwiftDate/blob/master/LICENSE")!)
            break;
        case 3:
            UIApplication.shared.open(URL(string: "https://icons8.de/license")!)
            break;
        default: break;
        }
    }
    
}
