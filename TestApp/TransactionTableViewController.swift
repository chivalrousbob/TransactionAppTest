//
//  TransactionTableViewController.swift
//  TestApp
//
//  Created by mac on 09/04/17.
//  Copyright © 2017 Ayoub. All rights reserved.
//

import UIKit

struct Transaction {
    var date : String
    var amount: String
    var description: String
    var currency: String
    
}
class TransactionTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    
    var list = [Transaction]()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTransactions()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        if(self.list.count >= indexPath.row){
            cell.labelAmount.text = "\(list[indexPath.row].amount) \(list[indexPath.row].currency)"
            cell.labelDate.text = list[indexPath.row].date
            cell.labelDescription.text = list[indexPath.row].description
            
        }
        print("cell")
        
        return cell
    }
    
    
    func getTransactions() {
        let alert = UIAlertController(title:"Transactions",message: "retrieving transactions...",preferredStyle: .alert)
        
        if(self.list.count == 0){
            self.present(alert,animated: true, completion: nil)
        }
        var list = [Transaction]()
        DataManager.shared.getTransactions { (transactions, nil) in
            for item in transactions {
                let date = item["date"] as! String
                let isoFormatter = ISO8601DateFormatter()
                let isoDate = isoFormatter.date(from: date)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/YYYY hh:mm"
                let dateFormatted = "\(formatter.string(from: isoDate!))"
                
                let amount = item["amount"] as! String
                let description = item["description"] as! String
                let currency = item["currency"] as! String
                let transaction = Transaction.init(date:dateFormatted , amount:amount , description: description, currency:currency)
                list.append(transaction)
            }
            DispatchQueue.main.async {
                print("list \(list)")
                self.list = list
                self.tableView.reloadData()
            }
            if(self.list.count == 0){
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    
}
