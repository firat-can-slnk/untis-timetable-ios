//
//  ManuelleEingabeViewController.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 14.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit

class ManuelleEingabeViewController: UIViewController {
    
    func updateSaveButtonState() {
        if (SchuleTextField.text != "" && ServerURLTextField.text != "") {
            AnmeldenButton.isEnabled = true
        }else{
            AnmeldenButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func textEditingChanged0(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBOutlet weak var ServerURLTextField: UITextField!
    @IBAction func ServerURLPrimaryAction(_ sender: Any) {
        SchuleTextField.becomeFirstResponder()
    }
    @IBOutlet weak var SchuleTextField: UITextField!
    @IBAction func SchulePrimaryAction(_ sender: Any) {
        AnmeldenAction(self)
    }
    @IBOutlet weak var AnmeldenButton: UIButton!
    @IBAction func AnmeldenAction(_ sender: Any) {
        
        let serverURL = ServerURLTextField.text!
        Global.selectedLoginRow = 0
        Global.tableData = [LoginViewController.SchoolData(Schulname: SchuleTextField.text!, Adresse: "-", Server: serverURL, SchuleCode: SchuleTextField.text!)]
        print(Global.tableData[Global.selectedLoginRow])
        performSegue(withIdentifier: "GoToCredentials", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TextView.text = NSLocalizedString("SchoolInfo", comment: "")
        
    }
    
}
