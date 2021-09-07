//
//  Follower.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 09.08.2021.
//

import Foundation


struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
