//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI


struct ContentView: View {
    
    @State var text: String = "DEBUG BASE"
    @StateObject var ticketManager = TicketTextManager()
    
    @StateObject var firestoreManager = FirestoreManager()

    
//   Tickets test
    
//    let ticketsTest = [
//        "lorem",
//        "ipsum",
//        "fasfas",
//        "fdsafasdfa",
//        "porqewporpqew",
//        "faca coisas legais",
//        "fasjlkdfjlkasdjfa"
//    ]
    
    let ticketsTest = [
        "Mete ssss",
    ]
    
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Text(text).font(.largeTitle)
                
                Button(action: {
//                    ticketManager.filterTickets(selectedTags: firestoreManager.selectedTags)
//                    text = ticketManager.PickTicket()
                },
                       label: {
                    Text("Generate Text")
                })
                .padding()
                
                
                NavigationLink {
                    FilterScreen()
                } label: {
                    Text("Filter Screen")
                }
                
                // debug only
                Button(action: {
                    Task {
                        try await firestoreManager.uploadFilter(filter: "Parque", ticketsArr: ticketsTest)
                    }
                },
                       label: {
                    Text("Send data")
                })
                .padding()
                
                Button(action: {
                    
                    if !firestoreManager.selectedTags.isEmpty {
                        Task {
                            let data = try await firestoreManager.getFiltersTickets()
                            let pickIndex = Int.random(in: 0..<data.count)
                            text = data[pickIndex]
                        }
                    } else {
                        text = "Select your filters!"
                    }
                },
                       label: {
                    Text("Print random ticket from Praia")
                })
                .padding()
            }
        }
        .environmentObject(firestoreManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
