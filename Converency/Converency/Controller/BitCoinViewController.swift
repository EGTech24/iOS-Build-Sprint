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
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCryptoData { (results) in
            switch results {
            case .success(let bitcoin):
                bitcoin.forEach { (data) in
                    self.symbolArray.append(data.value.symbol)
                    self.priceArray.append(data.value.buy)
                    self.locationArray.append(data.key)
                    DispatchQueue.main.async {
                        self.bitCoinPickerView.reloadAllComponents()
                    }
                }
            case .failure(let error):
                print("Failed to fetch bitcoin data: ", error)
            }
        }
        
        
        amountTextField.keyboardType = .decimalPad
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ConverencyViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    func currencyFormat(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func updateViews(input: Double) {
        guard let amountText = amountTextField.text, let theAmountText = Double(amountText) else { return }
        if amountTextField.text != "" {
            let total = theAmountText * activeCurrency
            priceLabel.text = "\(currencySelected)\(currencyFormat(amount: total))"
        }
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
        updateViews(input: activeCurrency)
    }
    
    //MARK: - JSON Function
    func fetchCryptoData(completion: @escaping (Result<Bitcoin, Error>) -> ()) {
        guard let url = URL(string: "https://blockchain.info/ticker") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let safeData = data else { return }
            
            do {
                let bitcoin = try JSONDecoder().decode(Bitcoin.self, from: safeData)
                completion(.success(bitcoin))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

