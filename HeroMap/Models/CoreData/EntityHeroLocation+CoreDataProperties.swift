//
//  EntityHeroLocation+CoreDataProperties.swift
//  HeroMap
//
//  Created by Nicolas on 26/09/22.
//
//

import Foundation
import CoreData


extension EntityHeroLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityHeroLocation> {
        return NSFetchRequest<EntityHeroLocation>(entityName: "EntityHeroLocation")
    }

    @NSManaged public var dateShow: Date
    @NSManaged public var id: String
    @NSManaged public var idHero: String
    @NSManaged public var latitud: Double
    @NSManaged public var longitud: Double
    @NSManaged public var relationToHero: EntityHero?

}

extension EntityHeroLocation : Identifiable {

}
