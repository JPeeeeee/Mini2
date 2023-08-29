//
//  FilterManager.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 28/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct DBFilter {
    let tickets: [String]?
    let no_tickets: Int?
}


final class FilterManager {
    
    static let shared = FilterManager()
    
    private let filterCollection = Firestore.firestore().collection("filters")
    
    private init() { }
    
    func createNewFilter(filter: String, ticketsArr: [String]) async throws {
        let tickets: [String: Any] = [
            "tickets": ticketsArr,
            "no_tickets": ticketsArr.count
        ]
        
        try await filterCollection.document(filter).setData(tickets, merge: false)
    }
    
    func getFilter(filter: String) async throws -> DBFilter {
        let snapshot = try await filterCollection.document(filter).getDocument()
        
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        let tickets = data["tickets"] as? [String]
        let no_tickets = data["no_tickets"] as? Int
        
        return DBFilter(tickets: tickets, no_tickets: no_tickets)
    }
}
