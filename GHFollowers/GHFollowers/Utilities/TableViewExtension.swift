//
//  TableViewExtension.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 14.08.2021.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeEmptyCells() {
        tableFooterView = UIView()
    }
}
