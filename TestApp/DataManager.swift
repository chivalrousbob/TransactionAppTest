//
//  DataManager.swift
//  TestApp
//
//  Created by Ayoub on 09/04/2017.
//  Copyright © 2017 Ayoub. All rights reserved.
//

import UIKit

let BASE_URL = "https://interviewer-api.herokuapp.com/"
enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

final class DataManager: NSObject {
    
    //MARK: - Singleton
    static let shared = DataManager()
    
    //MARK: - Properties
    
    //MARK: - Functions
    
    ///LOGIN
    func getValidToken(completion:@escaping ()->Void){
        let url = URL(string:BASE_URL+"login")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            
            if let data = data{
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                        throw JSONError.ConversionFailed
                    }
                    let token = "Bearer \(json["token"]!)"
                    let defaults = UserDefaults.standard
                    defaults.set(token, forKey: "token")
                    print("defaults = \(defaults.object(forKey: "token")!)")
                    //                    for obj in json {
                    //                        let object = obj //as! NSDictionary
                    //                        let token = "Bearer \(object.value(forKey: "token")!)"
                    //                        let defaults = UserDefaults.standard
                    //                        defaults.set(token, forKey: "token")
                    //                        print("defaults = \(defaults.data(forKey: "token"))")
                    //                    }
                    completion()
                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
                
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    ///BALANCE
    func getCurrentBalance(completion: @escaping (_ userDetail: [String:Any], _ error: NSError?)->Void){
        let url = URL(string:BASE_URL+"balance")
        var request = URLRequest(url:url!)
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token")! as! String
        print("balance token  = \(token)")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            if let data = data{
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                        throw JSONError.ConversionFailed
                    }
                   
                    print("json = \(json)")
                    completion(json, nil)

                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    ///Transactions
    func getTransactions(completion: @escaping (_ list: [[String:Any]], _ error: NSError?)->Void){
        let url = URL(string:BASE_URL+"transactions")
        var request = URLRequest(url:url!)
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token")! as! String
        print("balance token  = \(token)")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            if let data = data{
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
                        throw JSONError.ConversionFailed
                    }
                    
                    print("json = \(json)")
                    completion(json, nil)
                    
                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    
    ///Spend
    func newTransaction(amount:String,description:String,currency:String,completion: @escaping ()->Void){
        let url = URL(string:BASE_URL+"spend")
        var request = URLRequest(url:url!)
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token")! as! String
        print("balance token  = \(token)")
        let formatter = ISO8601DateFormatter()
        let date = formatter.string(from: Date())
        let parametrs = ["date":date,"description":description,"amount":amount,"currency":currency]
        //let parametrs = ["date":"2016-12-15T10:44:33Z","description":"test description","amount":"11","currency":"GBP"]
        print("parametrs \(parametrs)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parametrs, options: [])//JSONSerialization.WritingOptions.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        
        request.httpMethod = "post"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 204{
                // check for http errors
                print("statusCode should be 204, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
        completion()
    
    }
        task.resume()
    }


    
}
