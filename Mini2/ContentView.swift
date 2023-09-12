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
                    //                    .onAppear {
                    //                        firestoreManager.selectedTags = UserDefaults.standard.object(forKey: "selectedTags") as? Set<String> ?? Set<String>()
                    //                    }
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

            var arr = Set<String>()
            
            savedTags?.forEach({ item in
                arr.insert(item as! String)
            })
            
            firestoreManager.selectedTags = arr
            
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
