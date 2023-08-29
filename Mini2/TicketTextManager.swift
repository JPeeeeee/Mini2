//
//  TicketTextManager.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 25/08/23.
//

import Foundation
import SwiftUI

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
    private var filteredTickets: [Ticket] = [Ticket]()
    // Array with current tags
    
    init(){
        
        tickets = [Ticket(tags: ["Ao ar livre"], activity: "Correr para casa"),
                   Ticket(tags: ["Ao ar livre"], activity: "Passear no parque"),
                   Ticket(tags: ["Ao ar livre"], activity: "Acariciar um cachorro manco"),
                   Ticket(tags: ["Parque", "Ao ar livre"], activity: "Olhar diretamente para o sol por 10 segundos"),
                   Ticket(tags: ["Academia"], activity: "Pular 3 vezes"),
                   Ticket(tags: ["Em casa", "Academia"], activity: "Dançar muito"),
                   Ticket(tags: ["Em casa"], activity: "Comer miojo"),
                   Ticket(tags: ["Fora deste mundo!"], activity: "Diga para alguém que você tem 6 filhos")
        ]
    }
    
    public func filterTickets(selectedTags: Set<String>) {
        // Adds all the tickets that are cointained by the startingTags
        filteredTickets = tickets.filter{selectedTags.contains($0.tags)}
    }
    
    public func PickTicket() -> String{
        
        // Refills tickets if they have all been exhausted
        if (filteredTickets.count == 0){
            
            if (spentTickets.count == 0) {
                return "No more activities"
            }
            
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
