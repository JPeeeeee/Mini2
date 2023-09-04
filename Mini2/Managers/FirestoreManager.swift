//
//  FirestoreManager.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 29/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirestoreManager: ObservableObject {
    @Published var selectedTags: Set<String> = Set<String>()
    
    private var ticketsCancellable: AnyCancellable?
    
    @Published var possibleTickets: Set<DBFilter> = Set<DBFilter>()
    @Published var currentTicket: String = ""
    @Published var currentTicketTags: [String] = []
    
    func insert(filter: String) {
        possibleTickets = []
        self.selectedTags.insert(filter)
    }
    
    func remove(filter: String) {
        possibleTickets = []
        self.selectedTags.remove(filter)
    }
    
    // debug only
    func uploadFilter(filters: [String], ticketsArr: [String]) async throws {
        try await FilterManager.shared.createNewFilter(filters: filters, ticketsArr: ticketsArr)
    }
    
    func pickTicket() {
        if !possibleTickets.isEmpty {
            
            let res: DBFilter = possibleTickets.randomElement()!
            
            // remove ticket de atividades possiveis para nao repetir
            possibleTickets.remove(res)
            
            currentTicket = res.tickets?.randomElement() ?? "No more activities today!"
            currentTicketTags = res.filter_name ?? []
        } else {
            currentTicket = "No more activities today!"
            currentTicketTags = []
            
            // para caso queira repetir as atividades depois de ter repetido todas
             populatePossibleTickets()
        }
    }
    
    func populatePossibleTickets() {
        if !selectedTags.isEmpty {
            let publisher = FilterManager.shared.getTickets(filters: selectedTags)
            
            ticketsCancellable = publisher
                .sink(receiveCompletion: { error in
                    print("error \(error)")
                }, receiveValue: { tickets in
                    
                    print(tickets)
                    
                    tickets.forEach { item in
                        self.possibleTickets.insert(item)
                    }
                    self.ticketsCancellable?.cancel()
                })
        }
    }
}
