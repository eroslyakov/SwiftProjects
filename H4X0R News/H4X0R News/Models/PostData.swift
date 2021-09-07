//
//  PostData.swift
//  H4X0R News
//
//  Created by Rosliakov Evgenii on 01.08.2021.
//

import Foundation

struct PostData: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    let objectID: String
    let title: String
    let points: Int
    let url: String?
    var id: String { objectID }
}
