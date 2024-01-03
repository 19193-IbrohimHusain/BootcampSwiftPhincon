//
//  CoreDataHelper.swift
//  Snapgram
//
//  Created by Phincon on 21/12/23.
//


import CoreData
import Foundation
import UIKit

enum ProductCoreData {
    case cart(id: Int)
    case favorite(id: Int)
}

enum CoreDataResult {
    case added, failed, deleted, updated
}

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Snapgram")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private let predicateProductId: String = "productID == %d"
    private let predicateUserId: String = "userID == %@"
    
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
    
    func isEntityExist<T: NSManagedObject>(_ entity: T.Type, productId: Int, userId: String) -> Bool {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
            fetchRequest.predicate = NSPredicate(format: "\(predicateProductId) AND \(predicateUserId)", argumentArray: [productId, userId])
            let isExist = try context.fetch(fetchRequest)
            return !isExist.isEmpty
        } catch {
            print("Error fetching entity data: \(error) ")
            return false
        }
    }
    
    func addOrUpdateEntity<T: NSManagedObject>(_ entity: T.Type, for favorite: ProductCoreData, productId: Int, userId: String, properties: [String: Any]) -> CoreDataResult {
        do {
            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            fetchRequest.predicate = NSPredicate(format: "\(predicateProductId) AND \(predicateUserId)", argumentArray: [productId, userId])
            let existingEntries = try context.fetch(fetchRequest)
            
            if existingEntries.isEmpty {
                let newEntity = T(context: context)
                properties.forEach { key, value in
                    newEntity.setValue(value, forKey: key)
                }
                try context.save()
                return .added
            } else {
                switch favorite {
                case .cart(let id):
                    return updateItemQty(entity, productID: Int16(id), userId: userId)
                case .favorite(let id):
                    return deleteFavoriteItem(entity, productID: Int16(id), userId: userId)
                }
            }
        } catch {
            print("Error fetching or adding entity data: \(error)")
            return .failed
        }
    }
    
    func updateItemQty<T: NSManagedObject>(_ entity: T.Type, productID: Int16, userId: String, isIncrement: Bool = true) -> CoreDataResult {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = NSPredicate(format: "\(predicateProductId) AND \(predicateUserId)", argumentArray: [productID, userId])
        
        do {
            if let cartItem = try context.fetch(fetchRequest).first as? Cart {
                cartItem.quantity = isIncrement ? cartItem.quantity + 1 : cartItem.quantity - 1
                if cartItem.quantity == 0 {
                    context.delete(cartItem)
                    return .deleted
                }
                print(cartItem)
                try context.save()
                return .updated
            }
        } catch {
            print("Error Updating Product with ID: \(productID). Error: \(error)")
        }
        return .failed
    }
    
    func deleteFavoriteItem<T: NSManagedObject>(_ entity: T.Type, productID: Int16, userId: String, completion: (() -> Void)? = nil) -> CoreDataResult {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = NSPredicate(format: "\(predicateProductId) AND \(predicateUserId)", argumentArray: [productID, userId])
        
        do {
            if let favItem = try context.fetch(fetchRequest).first as? FavoriteProducts {
                context.delete(favItem)
                
                try context.save()
                completion?()
                return .deleted
            }
        } catch {
            print("Error Updating Product with ID: \(productID). Error: \(error)")
        }
        return .failed
    }
    
    func fetchItems<T: NSManagedObject>(_ entity: T.Type, userId: String) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.predicate = NSPredicate(format: predicateUserId, userId)
        let item = try context.fetch(fetchRequest)
        print(item)
        return item
    }
}
