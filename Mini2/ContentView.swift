//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var text: String = "DEBUG BASE"
    @ObservedObject var ticketManager: TicketTextManager = TicketTextManager()
    
    var body: some View {
        VStack{
            Text(text).font(.largeTitle)
            
            Button(action: {
                text = ticketManager.PickTicket()
            },
                   label: {
                Text("Generate Text")
            })
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
