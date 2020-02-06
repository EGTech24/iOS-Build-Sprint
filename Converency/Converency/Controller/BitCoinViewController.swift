//
//  BitCoinViewController.swift
//  Converency
//
//  Created by Enrique Gongora on 2/4/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class BitCoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //MARK: - Variables/IBOulets
    var locationArray: [String] = []
    var priceArray: [Double] = []
    var symbolArray: [String] = []
    var currencySelected = ""
    var activeCurrency = 0.0
    @IBOutlet weak var bitCoinPickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBAction func convertPressed(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let theAmountText = Double(amountText) else { return }
        if amountTextField.text != "" {
            let total = theAmountText * activeCurrency
            priceLabel.text = "\(currencySelected)\(currencyFormat(amount: total))"
            }
        }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCryptoData()
        amountTextField.keyboardType = .decimalPad
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ConverencyViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        convertButton.layer.cornerRadius = 5
        convertButton.clipsToBounds = true
        convertButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    func currencyFormat(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    
    //MARK: - PickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = priceArray[row]
        currencySelected = symbolArray[row]
    }
    
    //MARK: - JSON Function
    func fetchCryptoData(){
        guard let url = URL(string: "https://blockchain.info/ticker") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                guard let data = data else { return }
                let result = try JSONDecoder().decode([String: BitCoinData].self, from: data)
                for (key, value) in result{
                    self.locationArray.append(key)
                    self.priceArray.append(value.buy)
                    self.symbolArray.append(value.symbol)
                    DispatchQueue.main.async {
                        self.bitCoinPickerView.reloadAllComponents()
                    }
                }
            }catch{
                print(error)
            }
        }.resume()
    }
}

