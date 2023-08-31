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
import Combine

struct DBFilter {
    let filter_name: String?
    let tickets: [String]?
    let no_tickets: Int?
    
    init(filter_name: String?, tickets: [String]?, no_tickets: Int?) {
        self.filter_name = filter_name
        self.tickets = tickets
        self.no_tickets = no_tickets
    }
}


final class FilterManager {
    
    static let shared = FilterManager()
    
    private let filterCollection = Firestore.firestore().collection("filters")
    
    private let subject = PassthroughSubject<[String], Error>()
    
    private init() { }
    
    func createNewFilter(filter: String, ticketsArr: [String]) async throws {
        let tickets: [String: Any] = [
            "tickets": ticketsArr,
            "no_tickets": ticketsArr.count,
            "filter_name": filter
        ]
        
        try await filterCollection.document(filter).setData(tickets, merge: false)
    }
    
    func getTickets(filters: Set<String>) -> AnyPublisher<[String], Error> {
        let filtersArr = Array(filters)
        var res: [String] = []
        
        filterCollection.whereField("filter_name", in: filtersArr).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let dbFilters = querySnapshot!.documents.map({ item in
                    
                    let data = item.data()
                    let tickets = data["tickets"] as? [String]
                    let no_tickets = data["no_tickets"] as? Int
                    let filter_name = data["filter_name"] as? String
                    
                    return DBFilter(filter_name: filter_name, tickets: tickets, no_tickets: no_tickets)
                    
                }) as? [DBFilter] else {
                    print(querySnapshot!.documents.map({ $0.data() }))
                    return
                    
                }
                
                dbFilters.forEach {
                    res.append(contentsOf: $0.tickets ?? [])
                }
                
                self.subject.send(res)
                
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
