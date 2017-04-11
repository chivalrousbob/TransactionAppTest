//
//  BalanceViewController.swift
//  TestApp
//
//  Created by mac on 09/04/17.
//  Copyright © 2017 Ayoub. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var labelBalanceValue: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.getValidToken{ Void in
            self.getBalance()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if(self.labelBalanceValue.text == ""){
            self.activityIndicatorView.isHidden = false
        }
        if(defaults.object(forKey: "token") != nil){
            self.getBalance()
        }
        
    }
    
    func getBalance() {
        DataManager.shared.getCurrentBalance { (data, nil) in
            DispatchQueue.main.async {
                let balance = data["balance"] as! String
                let currency = data["currency"] as! String
                self.activityIndicatorView.isHidden = true
                self.labelBalanceValue.text = "\(balance) \(currency)"
            }
        }
        
    }
    
}
