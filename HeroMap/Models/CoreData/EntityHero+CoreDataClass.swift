//
//  EntityHero+CoreDataClass.swift
//  HeroMap
//
//  Created by Nicolas on 26/09/22.
//
//

import Foundation
import CoreData

@objc(EntityHero)
public class EntityHero: NSManagedObject {

}

extension EntityHero {
    static func create(from hero: Hero, context: NSManagedObjectContext) -> EntityHero {
        let eHero = EntityHero(context: context)
        eHero.id = hero.id
        eHero.name = hero.name
        eHero.favorite = hero.favorite ?? false
        eHero.descrip = hero.description
        eHero.photo = hero.photo
        
        return eHero
    }
    
    var hero: Hero {
        Hero(id: self.id,
             name: self.name,
             description: self.descrip,
             photo: self.photo ,
             favorite: self.favorite
        )
    }
}
