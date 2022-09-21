//
//  Cat.swift
//  thecatapp
//
//  Created by Admin on 21/09/22.
//

import Foundation

struct Kitty: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}
