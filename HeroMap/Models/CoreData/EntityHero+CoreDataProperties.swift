//
//  EntityHero+CoreDataProperties.swift
//  HeroMap
//
//  Created by Nicolas on 26/09/22.
//
//

import Foundation
import CoreData


extension EntityHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityHero> {
        return NSFetchRequest<EntityHero>(entityName: "EntityHero")
    }

    @NSManaged public var descrip: String
    @NSManaged public var favorite: Bool
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var photo: URL
    @NSManaged public var relationToLocation: NSSet?

}

// MARK: Generated accessors for relationToLocation
extension EntityHero {

    @objc(addRelationToLocationObject:)
    @NSManaged public func addToRelationToLocation(_ value: EntityHeroLocation)

    @objc(removeRelationToLocationObject:)
    @NSManaged public func removeFromRelationToLocation(_ value: EntityHeroLocation)

    @objc(addRelationToLocation:)
    @NSManaged public func addToRelationToLocation(_ values: NSSet)

    @objc(removeRelationToLocation:)
    @NSManaged public func removeFromRelationToLocation(_ values: NSSet)

}

extension EntityHero : Identifiable {

}
