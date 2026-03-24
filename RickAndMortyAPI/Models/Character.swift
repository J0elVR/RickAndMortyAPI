//
//  Character.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 13/03/26.
//

import UIKit

nonisolated
struct CharacterResponse: Codable {
    let info: Info
    let results: [RickAndMortyCharacter]
}

nonisolated 
struct RickAndMortyCharacter: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}

nonisolated
struct Info: Codable {
    let next: String?
}

