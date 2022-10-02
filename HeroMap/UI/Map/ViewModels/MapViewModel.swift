//
//  MapViewModel.swift
//  HeroMap
//
//  Created by Nicolas on 28/09/22.
//

import Foundation
import CoreLocation

final class MapViewModel {
    var onError: ((String)->Void)?
    var onSuccess: (()->Void)?
    private(set) var places: [Place] = []
    
    init( onError: ((String)->Void)? = nil,
          onSucces: (()->Void)? = nil){
        self.onError = onError
        self.onSuccess = onSucces
    }
    
    func loadLocations(for hero: Hero?) {
        do {
            guard let hero = hero, let eHero = try CoreDataManager.shared.fetchHeroes(by: "id == %@", with: hero.id).first else {
                self.onError?("No se encontraron registros")
                return
            }
            guard eHero.relationToLocation?.count ?? 0 > 0 else {
                self.onError?("No hay localizaciones para \(eHero.name)")
                return
            }
            eHero.relationToLocation?.forEach({
                if let location = $0 as? EntityHeroLocation {
                    places.append(Place(
                        title: eHero.name,
                        coordinate: CLLocationCoordinate2D(latitude: Double(location.latitud) , longitude: Double(location.longitud) ),
                        info: String(describing: location.dateShow)))
                }
            })
            self.onSuccess?()
        } catch { self.onError?("Error al leer los datos") }
    }
    
}
