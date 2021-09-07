//
//  DateExtension.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import Foundation

extension Date {
    
    func toFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.toDate() else {
            return "N/A"
        }
        return date.toFormatString()
    }
    
}
