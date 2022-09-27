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
    
}
