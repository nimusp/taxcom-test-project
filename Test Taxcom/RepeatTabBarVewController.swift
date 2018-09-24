//
//  AnotherViewController.swift
//  Test Taxcom
//
//  Created by Pavel Sumin on 22.09.2018.
//  Copyright © 2018 For Myself Inc. All rights reserved.
//

import UIKit

class RepeatTabBarVewController: UIViewController {
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var onChangeField: UITextField!
    @IBOutlet weak var notChangeField: UITextField!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.isHidden = true
        spiner.hidesWhenStopped = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard let inputNumber = numberField.text,
            let counter = Int(inputNumber) else { return }
        dismissKeyboard()
        sender.isEnabled = false
        spiner.startAnimating()
        
        let lottery = Lottery()
        lottery.raffleSeveralTimes(counter) {
            self.spiner.stopAnimating()
            sender.isEnabled = true
            
            self.notChangeField.text = String(format: "%d (%.2f)", lottery.withoutChangeWinsCounter,
                                              Float(lottery.withoutChangeWinsCounter) / Float(counter) * 100) + "%"
            self.onChangeField.text = String(format: "%d (%.2f)", lottery.onChangeWinsCounter,
                                             Float(lottery.onChangeWinsCounter) / Float(counter) * 100) + "%"
        }
    }

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        let alertTitle = "С увеличением числа повторений уменьшается случайная погрешность"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
