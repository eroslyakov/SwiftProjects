//
//  InputValidation.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 09.08.2021.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let pwdFormat = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}"
        let pwdPredicate = NSPredicate(format: "SELF MATCHES %@", pwdFormat)
        
        return pwdPredicate.evaluate(with: self)
    }
    
}
