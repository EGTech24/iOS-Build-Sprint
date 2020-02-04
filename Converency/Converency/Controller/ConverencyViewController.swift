//
//  ConverencyViewController.swift
//  Converency
//
//  Created by Enrique Gongora on 2/3/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class ConverencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //MARK: - Variables/IBOutlets
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        amountTextField.keyboardType = .asciiCapableNumberPad
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency: Double = 0
    
        func fetchData(){
            guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD") else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do{
                    let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let rates = myJson["rates"] as? NSDictionary{
                        for (key, value) in rates{
                            self.myCurrency.append((key as? String)!)
                            self.myValues.append((value as? Double)!)
                        }
                        print(self.myCurrency)
                        print(self.myValues)
                    }
                }catch{
                    print(error)
                }
            }.resume()
        }
    //MARK: - PickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
}
