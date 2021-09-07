//
//  stringExtension.swift
//  BMI Calculator
//
//  Created by Rosliakov Evgenii on 24.07.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation

extension String {
    subscript(range: ClosedRange<Int>) -> String {
        let startIdx = index(self.startIndex, offsetBy: range.min()!)
        let endIdx = index(startIdx, offsetBy: [self.count - 1, range.max()!].min()!)
        
        return String(self[startIdx...endIdx])
    }
}
