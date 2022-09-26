//
//  HeroModel.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import Foundation

struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool?
}

struct HeroLocation: Decodable {
    let id: String
    let latitud: Double
    let longitud: Double
    let dateShow: Date
    let hero: HeroID
    
    struct HeroID: Decodable {
        let id: String
    }
}
