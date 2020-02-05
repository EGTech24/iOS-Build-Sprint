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
    var activeCurrency = 0.0
    @IBOutlet weak var bitCoinPickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBAction func convertPressed(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let theAmountText = Double(amountText) else { return }
        if amountTextField.text != "" {
            priceLabel.text = String(format: "%.2f", theAmountText * activeCurrency)
        }
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        amountTextField.keyboardType = .numberPad
        bitCoinPickerView.dataSource = self
        bitCoinPickerView.delegate = self
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ConverencyViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
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
    }
    
    //MARK: - JSON Function
    func fetchData(){
        guard let url = URL(string: "https://blockchain.info/ticker") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                guard let data = data else { return }
                let result = try JSONDecoder().decode([String: BitCoinData].self, from: data)
                for (key, value) in result{
                    self.locationArray.append(key)
                    self.priceArray.append(value.buy)
                }
            }catch{
                print(error)
            }
        }.resume()
    }
}
