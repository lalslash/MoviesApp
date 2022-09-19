//
//  PeliculasPorGenero.swift
//  peliculasAPI
//
//  Created by user223791 on 9/12/22.
//

import Foundation

struct PeliculasPorGenero : Decodable {
    let results: [Results]
}

struct Results : Decodable {
    let adult: Bool
    let title: String
    let backdrop_path: String
    let overview: String
}
