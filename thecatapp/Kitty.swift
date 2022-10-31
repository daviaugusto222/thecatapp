//
//  Cat.swift
//  thecatapp
//
//  Created by Admin on 21/09/22.
//

//Creating a struct for Kitty
import Foundation

struct Kitty: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}
