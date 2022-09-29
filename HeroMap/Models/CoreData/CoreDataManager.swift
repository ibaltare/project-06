//
//  CoreDataManager.swift
//  HeroMap
//
//  Created by Nicolas on 26/09/22.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func save(heroes: [Hero]) throws {
        _ = heroes.map { EntityHero.create(from: $0, context: self.context) }
        try self.context.save()
    }
    
    func getLocalHeroes() throws -> [EntityHero] {
        let heroes = try context.fetch(EntityHero.fetchRequest())
        return heroes
    }
    
    func deleteAll() throws {
        let eHeros = try getLocalHeroes()
        eHeros.forEach { self.context.delete($0)}
        try self.context.save()
    }
    
    func deleteAllLocations() throws {
        let eLocations = try getLocalHeroesLocations()
        eLocations.forEach { self.context.delete($0)}
        try self.context.save()
    }
    
    func save(locations: [HeroLocation], eHero: EntityHero) throws {
        _ = locations.map { EntityHeroLocation.create(from: $0, for: eHero, context: self.context) }
        try self.context.save()
    }
    
    func getLocalHeroesLocations() throws -> [EntityHeroLocation] {
        let locations = try context.fetch(EntityHeroLocation.fetchRequest())
        return locations
    }
    
    func fetchHeroes(by predicate: String, value: String) throws -> [EntityHero]{
        let fetchRequest : NSFetchRequest<EntityHero> = EntityHero.fetchRequest()
        let predicate = NSPredicate(format: predicate, value)
        let sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        let fetchedResults = try context.fetch(fetchRequest)
        return fetchedResults
    }
    
    
    
    func getHero(by name:String) {
        
    }
    
    func getLocations(by heroId:String) {
        
    }
}
