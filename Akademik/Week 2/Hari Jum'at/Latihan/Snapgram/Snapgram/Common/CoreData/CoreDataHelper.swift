//
//  CoreDataHelper.swift
//  Snapgram
//
//  Created by Phincon on 21/12/23.
//


import CoreData
import Foundation
import UIKit

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Snapgram")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func clearCoreData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error clearing Core Data: \(error)")
        }
    }
    
    func isFavoriteEntityExist<T: NSManagedObject>(_ entity: T.Type, userId: String, predicateFormat: String, args: CVarArg...) -> Bool {
        do {
            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            fetchRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: args)
            let existingEntries = try context.fetch(fetchRequest)
            return !existingEntries.isEmpty
        } catch {
            print("Error fetching data: \(error)")
            return false
        }
    }
    
//    func addOrUpdateFavoriteEntity<T: NSManagedObject>(_ entity: T.Type, for favorite: ProductEnum, userId: String, properties: [String: Any]) {
//        do {
//            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
//            let predicateFormat = properties.keys.map { "\($0) == %@" }.joined(separator: " AND ")
//            let predicateValues = properties.values
//            
//            fetchRequest.predicate = NSPredicate(format: "\(predicateFormat) AND userId == %@", argumentArray: predicateValues + [userId])
//            let existingEntries = try context.fetch(fetchRequest)
//            
//            if existingEntries.isEmpty {
//                let newEntity = T(context: context)
//                properties.forEach { key, value in
//                    newEntity.setValue(value, forKey: key)
//                }
//                newEntity.setValue(userId, forKey: "userId")
//                try context.save()
//            } else {
//                switch favorite {
//                case .anime(let anime):
//                    deleteFavoriteEntity(T.self, predicateFormat: "title == %@ AND userId == %@", args: anime.title ?? "", userId)
//                    break
//                case .animeCharacter(let animeCharacter):
//                    deleteFavoriteEntity(T.self, predicateFormat: "name == %@ AND userId == %@", args: animeCharacter.character?.name ?? "", userId)
//                    break
//                case .animeCast(let animeCharacter):
//                    deleteFavoriteEntity(T.self, predicateFormat: "name == %@ AND userId == %@", args: animeCharacter.voiceActors?.first?.person?.name ?? "", userId)
//                    break
//                case .manga(let manga):
//                    deleteFavoriteEntity(T.self, predicateFormat: "title == %@ AND userId == %@", args: manga.title ?? "", userId)
//                    break
//                }
//            }
//        } catch {
//            print("Error fetching or adding entity data: \(error)")
//        }
//    }
    
    func deleteFavoriteEntity<T: NSManagedObject>(_ entity: T.Type, predicateFormat: String, args: CVarArg...) {
        do {
            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            fetchRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: args)
            let matchingEntities = try context.fetch(fetchRequest)
            
            for entity in matchingEntities {
                context.delete(entity)
            }
            
            try context.save()
        } catch {
            print("Error when deleting data: \(error)")
        }
    }
    
    func fetchFavoriteList<T: NSManagedObject>(_ entity: T.Type, userId: String) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        return try context.fetch(fetchRequest)
    }
}
