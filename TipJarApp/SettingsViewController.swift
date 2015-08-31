//
//  SettingsViewController.swift
//  TipJarApp
//
//  Created by Piedad Garnica on 5/8/15.
//  Copyright (c) 2015 Piedad Garnica. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentedRound: UISegmentedControl!
    
    @IBOutlet weak var minimumTipInputTextField: UITextField!
    
    @IBAction func onDoneButton(sender: UIButton) {
        if minimumTipInputTextField.text == "" {
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "minTip")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(minimumTipInputTextField.text, forKey: "minTip")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func minimumTipTextField(sender: UITextField) {
        
    }

    @IBAction func segmentedround(sender: UISegmentedControl) {
        
        println(segmentedRound.selectedSegmentIndex)
        
        switch segmentedRound.selectedSegmentIndex {
            
        case 0:
            
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "roundTotal")
            
        case 1:
            
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "roundTotal")
            
        default:
            
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "roundTotal")
            
        }
        
    }
    
    override func viewDidLoad() {
        println("Setings: viewDidLoad")
        super.viewDidLoad()
        
        var selectedSegment = NSUserDefaults.standardUserDefaults().objectForKey("roundTotal") as? Int ?? 2
        println(selectedSegment)
        var defaultMinTipRate = NSUserDefaults.standardUserDefaults().objectForKey("minTip") as? String ?? "15.0"
        println(defaultMinTipRate)
        segmentedRound.selectedSegmentIndex = selectedSegment
        minimumTipInputTextField.text = defaultMinTipRate

        // Customizing UITextField
        
        minimumTipInputTextField.layer.borderColor = mainColor.CGColor
        
        minimumTipInputTextField.layer.borderWidth = 1
        
        minimumTipInputTextField.layer.cornerRadius = 5
    
        var attributedMinTip = NSAttributedString(string: "15", attributes: [NSForegroundColorAttributeName: mainColor])
    
        self.minimumTipInputTextField.attributedPlaceholder = attributedMinTip
    
        self.minimumTipInputTextField.textColor = mainColor
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("Settings: viewDidAppear")
        super.viewDidAppear(true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Hyde the keyboard when tapping outside
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        println("touchesBegan")
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        println("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        
        return true
        
    }

}
