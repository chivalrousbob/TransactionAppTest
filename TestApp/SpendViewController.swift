//
//  SpendViewController.swift
//  TestApp
//
//  Created by mac on 10/04/17.
//  Copyright © 2017 Ayoub. All rights reserved.
//

import UIKit

class SpendViewController: UIViewController {

    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textFieldDescription: UITextView!
    @IBOutlet weak var textFieldCurrency: UITextField!
    @IBOutlet weak var buttonNewTansaction: UIButton!


    @IBAction func sendTransaction(_ sender: AnyObject) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        if(textFieldAmount.text == "" || textFieldDescription.text == "" || textFieldCurrency.text == ""){
            let alertController = UIAlertController(title: "Ops!", message: "fill the empty fields", preferredStyle: .alert)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            DataManager.shared.newTransaction(amount: textFieldAmount.text!, description: textFieldDescription.text!, currency: textFieldCurrency.text!, completion: {
                print("tete")
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Congratulations!", message: "Transaction added successfully", preferredStyle: .alert)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.textFieldAmount.text = ""
                    self.textFieldDescription.text = ""
                    self.textFieldCurrency.text = ""

                }
            })
        }
    }
}
