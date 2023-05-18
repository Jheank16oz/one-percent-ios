//
//  HomeVIewModel.swift
//  OnePercent
//
//  Created by Jhean Carlos Pineros Diaz on 10/05/23.
//

import Foundation
import Combine
import engine

public class  HomeViewModel: ObservableObject, Identifiable {

    @Published var goals: [engine.Goal] = []

    let repository: CoreDataGoalsRepository
    init(repository: CoreDataGoalsRepository) {
        self.repository = repository

        loadTodayGoals()
    }

    func loadTodayGoals() {
        Task {
            goals = await repository.listToday()
        }
    }



}
