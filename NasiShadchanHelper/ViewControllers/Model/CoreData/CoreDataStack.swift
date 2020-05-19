//
//  CoreDataStack.swift
//  NasiShadchanHelper
//
//  Created by user on 4/27/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

  // MARK: Properties
  private let modelName: String
    
  // MARK: - Initializers
  init(modelName: String) {
    self.modelName = modelName
  }

  lazy var mainContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

  private lazy var storeContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error \(error), \(error.localizedDescription)")
      }
    }
    return container
  }()

 
}

// MARK: Internal
extension CoreDataStack {

  func saveContext () {
    guard mainContext.hasChanges else { return }

    do {
      try mainContext.save()
    } catch let nserror as NSError {
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
