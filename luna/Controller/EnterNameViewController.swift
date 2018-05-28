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

class EnterNameViewController: UIViewController {

    
    @IBOutlet weak var tvCoin: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    let myPicker = UIPickerView()
    var coinArray : [String] = []
    
    var testDict: [String: String] = [:]
    var pageNo : Int = 0
    
    var baseUrl: String = ""
    var baseImageUrl: String = "https://www.cryptocompare.com"
    var finalImageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseUrl = "https://min-api.cryptocompare.com/data/top/totalvol?limit=100&page=\(pageNo)&tsym=USD"
        
        myPicker.delegate = self
        myPicker.dataSource = self
        tvCoin.inputView = myPicker
        
        getCoinList(url: baseUrl)
       
        if tvCoin.text == "" {
             btnSubmit.isEnabled = false
        }
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
            destinationVC.imagePassedFromPrevious = finalImageUrl
            destinationVC.dictionaryPassedFromPrevious = testDict
            
        }
    }
    
    //MARK: - Networking
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
    
    //MARK: - JSON Parsing
    func updateCoins(json : JSON) {
        
        for (_, value) in json["Data"] {
            
            let coins = value["CoinInfo"]["Name"].string
            let coinImage = value["CoinInfo"]["ImageUrl"].string
            
            let loopDict = [coins!: coinImage]
            
            for (key, _) in loopDict {
                coinArray.append(key)
                testDict[key] = coinImage
            }
           
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
//MARK: - UIPickerView Methodss
extension EnterNameViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
        let chosenCoin = coinArray[row]
        
        tvCoin.text = chosenCoin
        finalImageUrl = baseImageUrl + testDict[chosenCoin]!
        btnSubmit.isEnabled = true
    }
}

