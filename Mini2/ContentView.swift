//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

func check() -> Bool {
        if let referenceDate = UserDefaults.standard.object(forKey: "reference") as? Date {
            // reference date has been set, now check if date is not today
            if !Calendar.current.isDateInToday(referenceDate) {
                // if date is not today, do things
                // update the reference date to today
                UserDefaults.standard.set(Date(), forKey: "reference")
                return true
            }
        } else {
            // reference date has never been set, so set a reference date into UserDefaults
            UserDefaults.standard.set(Date(), forKey: "reference")
            return true
        }
        return false
    }

struct ContentView: View {
    
    @State var text: String = "DEBUG BASE"
    
    @StateObject var firestoreManager = FirestoreManager()

    
//   Tickets test
    
    let ticketsTest = [
        "lorem3",
        "ipsum3",
        "ipsum2",
        "fasfas3",
        "fdsafasdfa3",
        "porqewporpqe2w",
        "faca coisas legai2s",
        "fasjlkdfjlkasdjf2a"
    ]

    
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Text(firestoreManager.currentTicket).font(.largeTitle)
                
                NavigationLink {
                    FilterScreen()
                } label: {
                    Text("Filter Screen")
                }
                
                // debug only
                Button(action: {
                    Task {
                        try await firestoreManager.uploadFilter(filter: "Bar", ticketsArr: ticketsTest)
                    }
                },
                       label: {
                    Text("Send data")
                })
                .padding()
                
                Button(action: {
                    if !firestoreManager.selectedTags.isEmpty {
                        firestoreManager.pickTicket()
                        print(firestoreManager.currentTicket)
                    } else {
                        print("n tem nada marcado cara")
                    }
                },
                       label: {
                    Text("print data")
                })
                .padding()
            }
        }
        .environmentObject(firestoreManager)
        .onAppear {
            if check() {
                
            } else {
                
            }
        }
        .onChange(of: firestoreManager.selectedTags) { _ in
            firestoreManager.populatePossibleTickets()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
