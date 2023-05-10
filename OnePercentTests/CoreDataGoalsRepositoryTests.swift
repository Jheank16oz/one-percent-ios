//
//  CoreDataGoalsRepositoryTests.swift
//  OnePercentTests
//
//  Created by Jhean Carlos Pineros Diaz on 28/04/23.
//

import UIKit
import XCTest

@testable import OnePercent
@testable import engine
import CoreData


final class CoreDataGoalsRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_shouldInitWithViewContext() throws {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        let repository = CoreDataGoalsRepository(context: viewContext)
        
        XCTAssertNotNil(repository)
        XCTAssertNoThrow(repository as any GoalsRepository)
    }
    
    func test_should_create_managed_object_correctly(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let repository = CoreDataGoalsRepository(context: viewContext)
        
        XCTAssertEqual(repository.manage?.entity.name, "Goal")
    }
    
    func test_manage_should_has_changes_when_creates_entry(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let repository = CoreDataGoalsRepository(context: viewContext)
        let goal = Goal(subject: "Any subject", type: .educational)
        repository.create(goal: goal)
        
        let manage = repository.manage!
        
        XCTAssertEqual(manage.value(forKey: "subject") as! String, goal.subject)
        XCTAssertEqual(manage.value(forKey: "type") as! String, goal.type.rawValue)
        XCTAssertEqual(manage.value(forKey: "status") as! String, goal.status.rawValue)
    }
    
    func test_should_save_changes_when_creates_entry(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let repository = CoreDataGoalsRepository(context: viewContext)
        let goal = Goal(subject: "Any subject", type: .educational)
        
        let mcSpy = ManageContextSpy.init(concurrencyType: .mainQueueConcurrencyType)
        repository.context = mcSpy
        repository.create(goal: goal)
        
        XCTAssertEqual(mcSpy.saveInvocations, 1)
    }

    // MARK: Helpers
    class ManageContextSpy: NSManagedObjectContext {
        var saveInvocations = 0
        override func save() throws {
            saveInvocations += 1
            try super.save()
        }
    }
}

