//
//  EntityHeroLocation+CoreDataClass.swift
//  HeroMap
//
//  Created by Nicolas on 26/09/22.
//
//

import Foundation
import CoreData

@objc(EntityHeroLocation)
public class EntityHeroLocation: NSManagedObject {

}

extension EntityHeroLocation {
    static func create(from location:HeroLocation, for hero: EntityHero, context: NSManagedObjectContext) -> EntityHeroLocation {
        let eLocation = EntityHeroLocation(context: context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        eLocation.id = location.id
        eLocation.dateShow = dateFormatter.date(from: location.dateShow)
        eLocation.latitud = Double(location.latitud) ?? 0
        eLocation.longitud = Double(location.longitud) ?? 0
        eLocation.idHero = hero.id
        hero.mutableSetValue(forKey: "relationToLocation").add(eLocation)
        return eLocation
    }
}
