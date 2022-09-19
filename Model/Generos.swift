//
//  Generos.swift
//  peliculasAPI
//
//  Created by user223791 on 9/9/22.
//

import Foundation

struct Generos : Decodable {
    let genres: [Genres]
}

struct Genres : Decodable {
    let id: Int
    let name: String
}
