//
//  EnterNameViewController.swift
//  luna
//
//  Created by Brandan McDevitt on 10/05/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EnterNameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var tvCoin: UITextField!
    
    let myPicker = UIPickerView()
    var coinArray : [String] = []
    var sortedArray : [String] = []
    
    var pageNo : Int = 0
    
    var baseUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseUrl = "https://min-api.cryptocompare.com/data/top/totalvol?limit=100&page=\(pageNo)&tsym=USD"
        
        myPicker.delegate = self
        myPicker.dataSource = self
        tvCoin.inputView = myPicker
        
        getCoinList(url: baseUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        //performSegue(withIdentifier: EnterNameViewController, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCoinScreen" {
            
            let destinationVC = segue.destination as! CoinViewController
            
            destinationVC.coinPassedFromPrevious = tvCoin.text!
            
        }
    }
    
    //
    //    //MARK: - Networking
    //    /***************************************************************/
    //
    func getCoinList(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Coins received")
                    let coinListJSON : JSON = JSON(response.result.value!)
                    //print(coinListJSON)
                    
                    self.updateCoins(json: coinListJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    //
    func updateCoins(json : JSON) {
        
        for (key, value) in json["Data"] {
            
            if let coins = value["CoinInfo"]["Name"].string {
                print(key, coins)
                coinArray.append(coins)
                //sortedArray = coinArray.sorted(by: <)
            } else {
                tvCoin.text = "Unavailable"
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tvCoin.text = coinArray[row]
        //self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check that the touched view is your background view
        if touches.first?.view == self.view {
            // Do What Every You want to do
            self.view.endEditing(true)
        }
    }
    
}


