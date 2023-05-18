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
    let entityName = "Goal"



    func create(goal: engine.Goal) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        if let studEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let manage = NSManagedObject(entity: studEntity, insertInto: context)

            manage.setValue(goal.subject, forKey: GoalKeys.subject)
            manage.setValue(goal.type.rawValue, forKey: GoalKeys.type)
            manage.setValue(goal.status.rawValue, forKey: GoalKeys.status)

            do {
                try context.save()
            } catch let error as NSError {
                // TODO: errors on save
                print("error \(error)")
            }
        }
    }

    func listToday() async -> [engine.Goal] {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else { return []}
        let context = await appDelegate.persistentContainer.viewContext


       do {
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
           var result = [NSManagedObject]()
           // Execute Fetch Request
           let records = try context.fetch(fetchRequest)

           if let records = records as? [NSManagedObject] {
               result = records
           }

           return result.asGoalDict()
       } catch {
           print("Unable to fetch managed objects for entity.")
       }

       return []
    }
}

extension [NSManagedObject] {

    func asGoalDict() -> [engine.Goal]{
        self.map { $0.convert()}
    }
}

extension NSManagedObject {

    func convert() -> engine.Goal {
        let subject = self.value(forKey: "subject") as? String
        let type = self.value(forKey: "type") as? String
        let status = self.value(forKey: "status") as? String
        return engine.Goal(subject: subject, type: type, status: status)
    }
}

extension engine.Goal {

    init(subject: String?, type: String?, status: String?) {
        self.init(subject: subject ?? "",
                  type: GoalType.init(rawValue: type ?? "")!,
                  GoalStatus.init(rawValue: status ?? "")!
        )
    }
}
