//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

//struct Tags: Codable {
//    let tags: Set<String>
//    let id = UUID()
//}

struct ContentView: View {
    
    @State var text: String = "DEBUG BASE"
    
    @StateObject var firestoreManager = FirestoreManager()
    
    var body: some View {
        Group {
            if UserDefaults.isFirstAccess() == false {
                if check() {
                    DailyTicketView()
                        .environmentObject(firestoreManager)
                } else {
                    HomeView()
                        .environmentObject(firestoreManager)
                    
                }
            } else {
                OnboardingView()
                    .environmentObject(firestoreManager)
                    .onAppear {
                        UserDefaults.setFirstAccess(value: false)
                    }
            }
        }
        .onAppear {
            let savedTags = UserDefaults.standard.array(forKey: "selectedTags")
            let savedRerolled = UserDefaults.standard.bool(forKey: "pickedPrevious")
            
            let savedCurrentTicket = UserDefaults.standard.string(forKey: "currentTicket")
            let savedCurrentTicketTags = UserDefaults.standard.array(forKey: "currentTicketTags") as? [String]

            var arr = Set<String>()
            
            savedTags?.forEach({ item in
                arr.insert(item as! String)
            })
            
            print(check())
            
            firestoreManager.selectedTags = arr
            firestoreManager.currentTicket = savedCurrentTicket ?? "No more activities today!"
            
            if savedCurrentTicket == "" {
                firestoreManager.currentTicket = "No more activities today!"
            }
            
            firestoreManager.currentTicketTags = savedCurrentTicketTags ?? []
            
            if savedRerolled == true {
                firestoreManager.rerollEnum = .pickedPrevious
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
