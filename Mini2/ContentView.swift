//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

class SelectedTags: ObservableObject {
    @Published var arr: Set<String> = Set<String>()
}

struct ContentView: View {
    
    @StateObject var selectedTags = SelectedTags()
    
    @State var text: String = "DEBUG BASE"
    @ObservedObject var ticketManager: TicketTextManager = TicketTextManager()
    
    var body: some View {
        NavigationStack {
            VStack{
                Text(text).font(.largeTitle)
                
                Button(action: {
                    ticketManager.filterTickets(selectedTags: selectedTags)
                    text = ticketManager.PickTicket()
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
                
            }
        }
        .environmentObject(selectedTags)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
