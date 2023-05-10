//
//  CoreDataGoalsRepository.swift
//  OnePercent
//
//  Created by Jhean Carlos Pineros Diaz on 28/04/23.
//

import UIKit
import CoreData
import engine

class CoreDataGoalsRepository: NSObject, GoalsRepository {
    
    struct GoalKeys {
        static let subject = "subject"
        static let type = "type"
        static let status = "status"
    }
    
    var context: NSManagedObjectContext
    var manage: NSManagedObject?
    let entityName = "Goal"
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        if let studEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            manage = NSManagedObject(entity: studEntity, insertInto: context)
        }
    }
    
    func create(goal: engine.Goal) {
        manage?.setValue(goal.subject, forKey: GoalKeys.subject)
        manage?.setValue(goal.type.rawValue, forKey: GoalKeys.type)
        manage?.setValue(goal.status.rawValue, forKey: GoalKeys.status)
        
        do {
            try context.save()
        } catch let error as NSError {
            // TODO: errors on save
            print("error \(error)")
        }
    }
    
    func listToday() async -> [engine.Goal] {
        return []
    }
}


