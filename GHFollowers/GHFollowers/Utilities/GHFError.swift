//
//  GHFError.swift
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
    case noFollowers = "This user doesn't have any followers. You may become first 😉."
    case defaultsError = "There was an error relative to locally persisted data. Please try again."
    case alreadyInFavorites = "Already added to Favorites 🤌🏻"
    case somethingWrong = "Something went wrong"
    case emptyFavorites = "No Favorites?\nAdd one on the follower screen."
}
