//
//  ErrorLabelCreator.swift
//  Flash Chat iOS13
//
//  Created by Rosliakov Evgenii on 30.07.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class ErrorLabel {
    
    var errorLabel: UILabel
    var doesLabelContainMessage: Bool { errorLabel.text?.count ?? 0 > 0 }
    
    init(view: UIView) {
        let screenSize = UIScreen.main.bounds
        errorLabel = UILabel(frame: CGRect(x: 0, y: Int(screenSize.height / 2) - 30, width: Int(screenSize.width), height: 60))
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        view.addSubview(errorLabel)
    }
    
    func showErrorMessage(message: String) {
        errorLabel.text = message
    }
    
    func hideErrorMessage() {
        errorLabel.text = ""
    }
}
