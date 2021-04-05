//
//  CredentialsViewController.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 14.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import EasyAnimation

class CredentialsViewController: UIViewController {
    
    func updateSaveButtonState() {
        if (BenutzernameTextField.text != "" && PasswortTextField.text != "") {
            AnmeldenButton.isEnabled = true
        }else{
            AnmeldenButton.isEnabled = false
        }
    }
    
    
    @IBOutlet weak var AnmeldenButton: UIButton!
    @IBOutlet weak var BenutzernameTextField: UITextField!
    @IBOutlet weak var PasswortTextField: UITextField!
    @IBAction func BenutzernameTextFieldPrimaryAction(_ sender: Any) {
        PasswortTextField.becomeFirstResponder()
    }
    @IBAction func PasswordTextFieldPrimaryAction(_ sender: Any) {
        Anmelden(self)
    }
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func textEditingChanged0(_ sender: UITextField) {
        updateSaveButtonState()
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
        EasyAnimation.enable()
            self.errorMsgLabel.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
            self.errorMsgLabel.alpha = 0
        
    }
    
    @IBOutlet weak var errorMsgView: UIView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    func Login(Server: String, School: String = "", Username: String, Password: String) -> Bool {
        let server      = Server
        let school      = School
        let username    = Username
        let password    = Password
        let client      = Global.clientName
        let id:String   = "login"
        
        var url = Global.domain + "/untis2/?server=" + server
             url = url + "&school=" + school
             url = url + "&jsonParamsUser=" + username
             url = url + "&jsonParamsPassword=" + password
             url = url + "&jsonParamsClient=" + client
             url = url + "&jsonID=" + id
             url = url + "&jsonMethod=authenticate&date=now";
        print(url)
        print(getWebsiteContent(url: url))
        
        if (getWebsiteContent(url: url) == "Login not found"){
            
            UIView.animate(withDuration: 0.2, animations: {
                self.errorMsgLabel.alpha = 0
            })
            UIView.animate(withDuration: 0.1, animations: {
                self.errorMsgLabel.alpha = 1
            })
            return false
        }else{
            UIView.animate(withDuration: 0.1, animations: {
                self.errorMsgLabel.alpha = 0
            })
            return true
        }
    }
    func LoginFail() {
         print("Login Failed");
        KeychainWrapper.standard.removeObject(forKey: "LoginPasswort")
    }
    func LoginSuccess(){
        print("Login Successed");
        performSegue(withIdentifier: "GoToSecond", sender: self)
    }
    
    @IBAction func Anmelden(_ sender: Any) {
        

        // Try to save password in Keychain
        let saveSuccessful: Bool = KeychainWrapper.standard.set(PasswortTextField.text!, forKey: "LoginPasswort")
       
        
        if (saveSuccessful){ // If saving worked
            // Read password
            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "LoginPasswort")
            // Save Credentials in Global variable (WIHTOUT PASSWORD)
            Global.LoginCredentials =
                Global.LoginCredentialsStructure(Server: Global.tableData[Global.selectedLoginRow].Server, Schule: Global.tableData[Global.selectedLoginRow].Schulname, Benutzername: BenutzernameTextField.text!, Passwort: "LoginPasswort", SchuleCode: Global.tableData[Global.selectedLoginRow].SchuleCode);
            
            // Save Credentials locally (WITHOUT PASSWORD)
            let defaults = UserDefaults.standard
            defaults.set(Global.LoginCredentials.Server, forKey: "Server")
            defaults.set(Global.LoginCredentials.SchuleCode, forKey: "SchuleCode")
            defaults.set(Global.LoginCredentials.Benutzername, forKey: "Benutzername")
            defaults.set(Global.LoginCredentials.Passwort, forKey: "Passwort")
            
            /*****************
             TRY TO LOGIN
             ******************/
            if(Login(Server: defaults.string(forKey: "Server")!,
                     School: defaults.string(forKey: "SchuleCode")!,
                  Username: defaults.string(forKey: "Benutzername")!,
                  Password: retrievedString!) == true){
                LoginSuccess()
            }else{
                LoginFail()
            }
            
            
            
            
        }else{print("error while saving password")}
        
        
       
        
        //let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "myKey")
        
    }
}
