//
//  FirestoreManager.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 29/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    @Published var selectedTags: Set<String> = Set<String>()
    
    
    var possibleTickets: [String] = [String]()
    
    func insert(filter: String) {
        possibleTickets = []
        self.selectedTags.insert(filter)
    }
    
    func remove(filter: String) {
        possibleTickets = []
        self.selectedTags.remove(filter)
    }
    
    // debug only
    func uploadFilter(filter: String, ticketsArr: [String]) async throws {
        try await FilterManager.shared.createNewFilter(filter: filter, ticketsArr: ticketsArr)
    }
    
    func getFiltersTickets() async throws -> [String] {
        
        if possibleTickets.isEmpty {
            print("request")
            for item in selectedTags {
                let currentFilter = try await FilterManager.shared.getFilter(filter: item)
                
                currentFilter.tickets?.forEach({ item in
                    possibleTickets.append(item)
                })
            }
            
            return possibleTickets
        }
        
        return possibleTickets
    }
}
