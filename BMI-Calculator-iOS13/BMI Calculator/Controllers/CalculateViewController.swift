//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatoBrain = CalculatorBrain()
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightSlider.setValue(1.5, animated: false)
        weightSlider.setValue(100.0, animated: false)
    }

    @IBAction func changeHeight(_ sender: UISlider) {
        let value = String(format: "%.2f", sender.value)
        heightLabel.text = "\(value)m"
    }
    
    @IBAction func changeWeight(_ sender: UISlider) {
        let value = String(format: "%.0f", sender.value)
        weightLabel.text = "\(value)Kg"
    }
    
    @IBAction func pressCalculate(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        calculatoBrain.calculateBMI(height: height, weight: weight)
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.bmiValue = calculatoBrain.getBMIString()
            destinationVC.bgColor = calculatoBrain.getColor()
            destinationVC.advice = calculatoBrain.getAdvice()
        }
    }
}

