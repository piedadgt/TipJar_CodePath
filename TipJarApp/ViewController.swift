//
//  ViewController.swift
//  TipJarApp
//
//  Created by Piedad Garnica on 5/8/15.
//  Copyright (c) 2015 Piedad Garnica. All rights reserved.
//

import UIKit

let mainColor: UIColor = UIColor(red: (254.0 / 255.0), green: (250.0 / 255.0), blue: (210.0 / 255.0), alpha: 1.0)

let segmentedControlImages = ["BadIcon", "SosoIcon", "OKIcon", "GoodIcon", "ExcellentIcon"]

let segmentedControlImagesSelected = ["BadIconSelected", "SosoIconSelected", "OKIconSelected", "GoodIconSelected", "ExcellentIconSelected"]


class ViewController: UIViewController {
    
    @IBOutlet weak var inputBillTextField: UITextField!
    
    @IBOutlet weak var inputTaxTextField: UITextField!
    
    @IBOutlet weak var inputPeopleTextField: UITextField!

    @IBOutlet weak var qualityOutputLabel: UILabel!
    
    @IBOutlet weak var segmentedRate: UISegmentedControl!
    
    @IBAction func calcButtonDidPress(sender: AnyObject) {
        
        self.calcTotal()
        
    }
    
    var totalResult: Double!
    
    var subTotal: Double!
    
    var perPerson: Double!
    
    var finalTip: Double!
    
    var roundTotal: Int!
    
    var numberOfPeople: Double!
    
    var tax: Double!
    
    var minTip: NSString!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Customizing UITextFields
        
        var editTextField: [UITextField] = [inputBillTextField, inputTaxTextField, inputPeopleTextField]
        
        for textField in editTextField {
            
            textField.layer.borderColor = mainColor.CGColor
            
            textField.layer.borderWidth = 1
            
            textField.layer.cornerRadius = 5
            
            }

        var attributedTextBill = NSAttributedString(string: "$0.00", attributes: [NSForegroundColorAttributeName: mainColor])
        
        var attributedTextTax = NSAttributedString(string: "0%", attributes: [NSForegroundColorAttributeName: mainColor])
        
        var attributedTextPeople = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: mainColor])
        
        
        self.inputBillTextField.text = nil
        
        self.inputBillTextField.attributedPlaceholder = attributedTextBill
        
        self.inputBillTextField.textColor = mainColor
        
        
        self.inputTaxTextField.text = nil
        
        self.inputTaxTextField.attributedPlaceholder = attributedTextTax
        
        self.inputTaxTextField.textColor = mainColor
        
        
        self.inputPeopleTextField.text = nil
        
        self.inputPeopleTextField.attributedPlaceholder = attributedTextPeople
        
        self.inputPeopleTextField.textColor = mainColor
        
        
        // Customizing UISegmentedControl
        
        var numberOfSegments = self.segmentedRate.numberOfSegments
        
        self.segmentedRate.selectedSegmentIndex = UISegmentedControlNoSegment
        
        for index in 0...numberOfSegments-1 {
            
            self.segmentedRate.setImage(UIImage(named: segmentedControlImages[index])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forSegmentAtIndex: index)
            
            }
        
        self.segmentedRate.frame = CGRect(origin: self.segmentedRate.frame.origin, size: CGSize(width: self.segmentedRate.frame.size.width, height: 50.0))
        
        self.segmentedRate.addTarget(self, action: "segmentedRateDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        //Loads the default settings
        
        roundTotal = NSUserDefaults.standardUserDefaults().objectForKey("roundTotal") as? Int ?? 2
        
        println("Main: viewDidAppear: RoundTotal = \(roundTotal)")
       
        minTip = NSUserDefaults.standardUserDefaults().objectForKey("minTip") as? NSString ?? NSString(string: "15.0")
        
        println("Main: viewDidAppear: MinTip = " + String(minTip))
        
    }
    
    
    //Updates qualityOuputLabel after the segmented control selection is changed
    
    func segmentedRateDidChange(sender: UISegmentedControl) {
        
        switch segmentedRate.selectedSegmentIndex {
            
        case 0:
            
            qualityOutputLabel.text = "BAD"
            
        case 1:
            
            qualityOutputLabel.text = "SO SO"
            
        case 2:
            
            qualityOutputLabel.text = "OK"
            
        case 3:
            
            qualityOutputLabel.text = "GOOD"
            
        case 4:
            
            qualityOutputLabel.text = "EXCELLENT"
            
        default:
            
            qualityOutputLabel.text = ""
            
        }
        
        //Animates the label when it chages
        
        qualityOutputLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            
            self.qualityOutputLabel.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        
        //Changes the image displayed on the segmented control when it is selected
        
        for index in 0...sender.numberOfSegments-1 {
            
            println(index)
            
            if index == sender.selectedSegmentIndex {
                
                self.segmentedRate.setImage(UIImage(named: segmentedControlImagesSelected[index])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forSegmentAtIndex: index)
                
            } else {
                
                self.segmentedRate.setImage(UIImage(named: segmentedControlImages[index])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forSegmentAtIndex: index)
        
            }
            
        }
        
    }
    
    
    //Calculates the total and total per person including tip and taxes and rounds the result according to the selecton in settings
    
    func calcTotal() {
        
        var tmp = (inputPeopleTextField.text as? NSString)?.doubleValue ?? 1
        
        numberOfPeople = tmp == 0 ? 1 : tmp
        
        var tmpTax = (inputTaxTextField.text as? NSString)?.doubleValue ?? 10
        
        tax = ( tmpTax / 100 ) + 1 // 1.xx
        
        subTotal = ( (inputBillTextField.text as? NSString)?.doubleValue ?? 0 ) / tax
        
        finalTip = self.calcTip() // 1.xx
        
        
        println("Main: calcTotal: numberOfPeople = \(numberOfPeople)")
        
        println("Main: calcTotal: tax = \(tax)")
        
        println("Main: calcTotal: subTotal = \(subTotal)")
        
        println("Main: calcTotal: finalTip = \(finalTip)")
        
        
        totalResult = ( (inputBillTextField.text as? NSString)?.doubleValue ?? 0) + (finalTip - 1 ) * subTotal
        
        println("Main: calcTotal: totalResult = \(totalResult)")
        
        
        perPerson = totalResult / numberOfPeople
        
        println("Main: calcTotal: perPerson = \(perPerson)")
        
        
        if roundTotal == 0 {
                
            perPerson = ceil(perPerson)
            
            //Recalculates the total after rounding the numbers
            
            totalResult = perPerson * numberOfPeople
            
            println("Main: calcTotal: roundTotal = \(roundTotal)")
                
        } else if roundTotal == 1 {
                    
            perPerson = floor(perPerson)
            
            //Recalculates the total after rounding the numbers
            
            totalResult = perPerson * numberOfPeople
            
            println("Main: calcTotal: roundTotal = \(roundTotal)")
                
        }
        
    }
    
    //Calculates the tip (1.x)
    
    func calcTip() -> Double {
        
        var fixTip = ((minTip.doubleValue) / 100 ) + 1
        
        println("Main: calcTip: fixTip = \(fixTip)")
        
        var varTip = Double(arc4random_uniform(11)) / 1000.0
        
        println("Main: calcTip: varTip = \(varTip)")
        
        switch segmentedRate.selectedSegmentIndex {
            
        case 0:
            
            return fixTip
            
        case 1:
            
            return 0.01 + fixTip + varTip
            
        case 2:
            
            return 0.02 + fixTip + varTip
            
        case 3:
            
            return 0.03 + fixTip + varTip
            
        case 4:
            
            return 0.04 + fixTip + varTip
            
        default:
            
            return fixTip
            
        }
        
    }
    
    //To transfer the variable values to the results view
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToResults" {
            
            (segue.destinationViewController as! ResultsViewController).totalOutput = totalResult
            
            (segue.destinationViewController as! ResultsViewController).perPersonOutput = perPerson
            
            (segue.destinationViewController as! ResultsViewController).tipPercentage = finalTip
            
            (segue.destinationViewController as! ResultsViewController).numberOfPeople = numberOfPeople
            
            (segue.destinationViewController as! ResultsViewController).subTotal = subTotal
            
            (segue.destinationViewController as! ResultsViewController).tax = tax
            
        }
        
    }
    
    
    //Hyde the keyboard when tapping outside
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}

