//
//  CoinViewController.swift
//  luna
//
//  Created by Brandan McDevitt on 10/05/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var coinPassedFromPrevious: String?
    var imagePassedFromPrevious: String?
    var dictionaryPassedFromPrevious: [String:String] = [:]
    
    var priceUrl : String?
    var currencyChoice = "GBP"
    
    var currencyChange : String = ""
    
    let currency = ["GBP","USD", "EUR"]
    let currencyPicker = UIPickerView()
    
    @IBOutlet weak var tvCoinName: UILabel!
    @IBOutlet weak var selectedCoinImage: UIImageView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var tvCurrency: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lbl24High: UILabel!
    @IBOutlet weak var lbl24Low: UILabel!
    @IBOutlet weak var lblMktCap: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        tvCurrency.inputView = currencyPicker
        lblPrice.adjustsFontSizeToFitWidth = true
        priceUrl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(coinPassedFromPrevious!)&tsyms=\(currencyChoice)"
        
        tvCoinName.text = coinPassedFromPrevious!
        loadImage()
        getPrice(url: priceUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage() {
        if let url = NSURL(string: imagePassedFromPrevious!) {
            if let data = NSData(contentsOf: url as URL) {
                selectedCoinImage.image = UIImage(data: data as Data)
            }
        }
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        getPrice(url: currencyChange)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let chosenCurrency = currency[row]
        currencyChoice = chosenCurrency
        tvCurrency.text = "\(chosenCurrency) ⌄"
        
        let baseUrlChange = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(coinPassedFromPrevious!)&tsyms="

        currencyChange = baseUrlChange + currencyChoice
        
        getPrice(url: currencyChange)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check that the touched view is your background view
        if touches.first?.view == self.view { //TODO: fix issue that touches within new view doesnt register
            // Do What Every You want to do
            self.view.endEditing(true)
        }
    }
    
    func getPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess!")
                    let priceJSON : JSON = JSON(response.result.value!)
                    print(priceJSON)
                    
                    self.updatePrice(json: priceJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    func updatePrice(json : JSON) {
        
        let currentPrice = json["DISPLAY"][coinPassedFromPrevious!][currencyChoice]["PRICE"].string
        let high24 = json["DISPLAY"][coinPassedFromPrevious!][currencyChoice]["HIGH24HOUR"].string
        let low24 = json["DISPLAY"][coinPassedFromPrevious!][currencyChoice]["LOW24HOUR"].string
        let marketCap = json["DISPLAY"][coinPassedFromPrevious!][currencyChoice]["MKTCAP"].string
        
        lblPrice.text = currentPrice!
        lbl24High.text = high24!
        lbl24Low.text = low24!
        lblMktCap.text = marketCap!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
