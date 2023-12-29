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
    case cart(entity: ProductModel)
    case favorite(entity: ProductModel)
}

enum FetchProductCoreData {
    case cart, favorite
}

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
            print("Success deleting")
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
    
    func addOrUpdateEntity<T: NSManagedObject>(_ entity: T.Type, for favorite: ProductCoreData, userId: String, properties: [String: Any]) -> Bool {
        do {
            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            let predicateFormat = properties.keys.map { "\($0) == %@" }.joined(separator: " AND ")
            let predicateValues = properties.values
            
            fetchRequest.predicate = NSPredicate(format: "\(predicateFormat)", argumentArray: [predicateValues])
            let existingEntries = try context.fetch(fetchRequest)
            
            if existingEntries.isEmpty {
                let newEntity = T(context: context)
                properties.forEach { key, value in
                    newEntity.setValue(value, forKey: key)
                }
                try context.save()
                return true
            } else {
                switch favorite {
                case .cart(let item):
                    deleteFavoriteEntity(T.self, predicateFormat: "productID == %@ AND userID == %@", args: item.id, userId)
                    return true
                case .favorite(let product):
                    deleteFavoriteEntity(T.self, predicateFormat: "productID == %@ AND userID == %@", args: product.id, userId)
                    return true
                }
            }
        } catch {
            print("Error fetching or adding entity data: \(error)")
            return false
        }
    }
    
    func saveItemToCart(data: ProductModel) -> Bool {        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productID == %d", data.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let _ = results.first as? NSManagedObject {
                print("Product with ID \(data.id) already exists in cart.")
                return true
            } else {
                if let cartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: context) {
                    let productItem = NSManagedObject(entity: cartEntity, insertInto: context)
                    
                    productItem.setValue(data.id, forKey: "productID")
                    productItem.setValue(data.name, forKey: "name")
                    productItem.setValue(data.price, forKey: "price")
                    productItem.setValue(data.galleries?.last?.url, forKey: "image")
                    productItem.setValue(1, forKey: "quantity")
                    
                    do {
                        try context.save()
                        print("Saved to history")
                        return true
                    } catch {
                        print("Failed to save item to cart: \(error)")
                        return false
                    }
                }
            }
        } catch {
            print("Error fetching existing movie: \(error)")
            return false
        }
        
        // This return statement ensures there's always a return value
        return false
    }
    
    func addFavoriteProduct(data: ProductModel) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProducts")
        fetchRequest.predicate = NSPredicate(format: "productID == %d", data.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let _ = results.first as? NSManagedObject {
                print("Product with ID \(data.id) already exists in wishlist.")
                return true
            } else {
                if let cartEntity = NSEntityDescription.entity(forEntityName: "FavoriteProducts", in: context) {
                    let productItem = NSManagedObject(entity: cartEntity, insertInto: context)
                    
                    productItem.setValue(data.id, forKey: "productID")
                    productItem.setValue(data.name, forKey: "name")
                    productItem.setValue(data.price, forKey: "price")
                    productItem.setValue(data.galleries?.last?.url, forKey: "imageLink")
                    productItem.setValue(data.category.name, forKey: "category")
                    
                    do {
                        try context.save()
                        print("Saved to Wishlist")
                        return true
                    } catch {
                        print("Failed to save item to wishlist: \(error)")
                        return false
                    }
                }
            }
        } catch {
            print("Error fetching existing item: \(error)")
            return false
        }
        
        // This return statement ensures there's always a return value
        return false
    }
    
    func deleteFavProduct(id: Int16) {
        let fetchRequest: NSFetchRequest<FavoriteProducts> = FavoriteProducts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productID == %d", id)
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            try context.save()
            print("Success")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func isFavProductExist(id: Int16) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteProducts> = FavoriteProducts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productID == %d", id)
        do {
            let items = try context.fetch(fetchRequest)
            return true
        } catch {
            print("Error: \(error)")
            return false
        }
    }

    func clearCoreDataCache() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            do {
                let entities = try context.fetch(fetchRequest)
                for entity in entities {
                    context.delete(entity as! NSManagedObject)
                }
                try context.save()
                
                // Call the completion handler with success
                print("Success delete")
            } catch {
                // Call the completion handler with failure and pass the error
                print("Failed delete")
            }
        }
    
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
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userId)
        return try context.fetch(fetchRequest)
    }
    
    func fetchCartItems() -> [Cart]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            return fetchedResults as? [Cart]
        } catch {
            print("Failed to fetch data: \(error)")
            return nil
        }
    }
    
    func fetchFavProducts() -> [FavoriteProducts]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProducts")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            return fetchedResults as? [FavoriteProducts]
        } catch {
            print("Failed to fetch data: \(error)")
            return nil
        }
    }
}
