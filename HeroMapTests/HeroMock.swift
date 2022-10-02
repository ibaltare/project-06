//
//  HeroMock.swift
//  HeroMapTests
//
//  Created by Nicolas on 02/10/22.
//

import Foundation
@testable import HeroMap

final class HeroMock {
    static var heroTest: Hero = Hero(
        id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
        name: "Goku",
        description: "Test",
        photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300")!,
        favorite: false
    )
    
    static var heroLocationTest: HeroLocation = HeroLocation(
        id: "6982D037-A9E0-4EE1-8BFA-FF17874D6DD5",
        latitud: "40.437149142667955",
        longitud: "-3.700824111001255",
        dateShow: "2022-02-20T00:00:00Z",
        hero: HeroLocation.HeroID(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
    )
    
    static var heroNotFound: Hero = Hero(
        id: "001",
        name: "Test",
        description: "Test",
        photo: URL(string: "https://www.avanderlee.com")!,
        favorite: false
    )
}
