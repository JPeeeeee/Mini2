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

struct DBFilter: Hashable {
    let filter_name: [String]?
    let tickets: [String]?
    let no_tickets: Int?
    
    init(filter_name: [String]?, tickets: [String]?, no_tickets: Int?) {
        self.filter_name = filter_name
        self.tickets = tickets
        self.no_tickets = no_tickets
    }
}


final class FilterManager {
    
    static let shared = FilterManager()
    
    private let filterCollection = Firestore.firestore().collection("filters")
    
    private let subject = PassthroughSubject<[DBFilter], Error>()
    
    private init() { }
    
    func createNewFilter(filters: [String], ticketsArr: [String]) async throws {
        
        var filter_name = ""
        
        filters.forEach { item in
            filter_name.append(item)
        }
        
        let tickets: [String: Any] = [
            "tickets": ticketsArr,
            "no_tickets": ticketsArr.count,
            "filter_name": filters
        ]
        
        try await filterCollection.document(filter_name).setData(tickets, merge: false)
    }
    
    func getTickets(filters: Set<String>) -> AnyPublisher<[DBFilter], Error> {
        let filtersArr = Array(filters)
        var res: [DBFilter] = []
        
        filterCollection.whereField("filter_name", arrayContainsAny: filtersArr).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let dbFilters = querySnapshot!.documents.map({ item in
                    
                    let data = item.data()
                    let tickets = data["tickets"] as? [String]
                    let no_tickets = data["no_tickets"] as? Int
                    let filter_name = data["filter_name"] as? [String]
                    
                    if filtersArr.contains(filter_name!) {
                        return DBFilter(filter_name: filter_name, tickets: tickets, no_tickets: no_tickets)
                    } else {
                        return DBFilter(filter_name: [], tickets: [], no_tickets: 0)
                    }
                    
                }) as? [DBFilter] else {
                    print(querySnapshot!.documents.map({ $0.data() }))
                    return
                    
                }
                
                dbFilters.forEach {
                    if $0.no_tickets != 0 {
                        res.append($0)
                    }
                }
                
                self.subject.send(res)
                
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
