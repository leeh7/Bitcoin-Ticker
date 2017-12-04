//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by David Lee on 11/22/17.
//  Copyright © 2017 David Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyArraySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySelected = ""

    //IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
       
    }
    
    //number of components in picker, 1 for column of currency in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows in picker, correspond to number of entries in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //define picker entry data/value, corresponding to name/title of entry in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //action upon selection in picker, generate URL to send as web request via alamofire and select respective currency label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySelected = currencyArraySymbols[row]
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL)
        
    }
    
    //Generate web request using alamofire
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin price data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
    }
    
    //Label update with bitcoin price/currency label
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySelected)"+"\(bitcoinResult)"
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}

