//
//  ViewController.swift
//  Test Taxcom
//
//  Created by Pavel Sumin on 21.09.2018.
//  Copyright © 2018 For Myself Inc. All rights reserved.
//

import UIKit

class LotteryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var doorButtons: [UIButton]!
    @IBOutlet weak var repeatButton: UIButton!
    
    private var lottery: Lottery!
    private var status: LotteryStatus = .intro {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottery = Lottery()
        prepareForLottery()
    }
    
    @IBAction func doorTapped(_ sender: UIButton) {
        lottery.selectDoor(sender.tag)
        status = lottery.status
    }
    
    @IBAction func repeatButtonTapped(_ sender: UIButton) {
        prepareForLottery()
    }
    
    private func prepareForLottery() {
        lottery.setupLottery()
        for doorButton in doorButtons {
            doorButton.setImage(UIImage(named: "door"), for: .normal)
            doorButton.isUserInteractionEnabled = true
        }
        repeatButton.isHidden = true
    }
    
    private func updateView() {
        switch status {
        case .firstDoorWasOpen:
            let index = lottery.goatIndex
            textView.text = lottery.text
            UIView.transition(with: view, duration: 1.5, options: .transitionCrossDissolve, animations: {
                self.doorButtons[index].setImage(UIImage(named: "goat"), for: .normal)
                self.doorButtons[index].isUserInteractionEnabled = false
                self.textView.text = self.lottery.text
            }, completion: nil)
            
        case .secondDoorWasOpen:
            let index = lottery.carIndex
            let win = lottery.getTrophy
            UIView.transition(with: view, duration: 1.5, options: .transitionCrossDissolve, animations: {
                for button in self.doorButtons {
                    button.setImage(UIImage(named: "goat"), for: .normal)
                }
                //setup door with trophy
                self.doorButtons[index].setImage(UIImage(named: "car"), for: .normal)
                
                self.textView.text = self.lottery.text
            }) { (_) in
                let alertTitle = win ? "Поздравляю с победой!" : "К сожалению, вы проиграли."
                let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.repeatButton.isHidden = false
            }
        case .intro:
            break
        }
    }

}

