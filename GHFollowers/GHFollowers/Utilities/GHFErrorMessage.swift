//
//  ErrorMessages.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 10.08.2021.
//

import Foundation

enum GHFError: String, Error {
    case emptyUsername = "Please enter a username. We need to know who to look for 😀"
    case invalidUrl = "Invalid url. You can do nothing about that."
    case connectionError = "Unable to finish request. Check your Network connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "Invalid data from the server. Please try again"
}
