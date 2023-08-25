//
//  TicketTextManager.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 25/08/23.
//

import Foundation

struct Ticket: Equatable{
    let tags: [String]
    let activity: String
}

class TicketTextManager: ObservableObject{
    // Array with all unused tickets
    private var tickets: [Ticket]
    // Array with tickets that were already picked
    private var spentTickets: [Ticket] = [Ticket]()
    // Array with filtered unused tickets
    private var filteredTickets: [Ticket]
    // Array with current tags
    private var chosenTags: [String]
    
    init(){
        let startingTags: [String] = ["tag1", "tag2"]
        
        tickets = [Ticket(tags: ["tag1", "tag2", "tag3"], activity: "Correr para casa"),
                   Ticket(tags: ["tag2", "tag3"], activity: "Passear no parque"),
                   Ticket(tags: ["tag2"], activity: "Pular 3 vezes"),
                   Ticket(tags: ["tag1", "tag2"], activity: "Dançar"),
                   Ticket(tags: ["tag1"], activity: "Comer miojo")
        ]
        
        chosenTags = startingTags
        
        // Adds all the tickets that are cointained by the startingTags
        filteredTickets = tickets.filter{startingTags.contains($0.tags)}
    }
    
    public func PickTicket() -> String{
        // Refills tickets if they have all been exhausted
        if (filteredTickets.count == 0){
            filteredTickets.append(contentsOf: spentTickets)
            tickets.append(contentsOf: spentTickets)
            spentTickets = [Ticket]()
        }
        
        // Random ticket index
        let ranNum = Int.random(in: 0..<filteredTickets.count)
        
        let currentTicket = filteredTickets.remove(at: ranNum)
        
        tickets.remove(at: tickets.firstIndex(of: currentTicket)!)
        spentTickets.append(currentTicket)
        
        return spentTickets.last?.activity ?? "No activity"
    }
}
