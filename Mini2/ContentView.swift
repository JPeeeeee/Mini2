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
        
        if UserDefaults.isFirstAccess() == false {
            if !check() {
                DailyTicketView()
                    .environmentObject(firestoreManager)
//                    .onAppear {
//                        firestoreManager.selectedTags = UserDefaults.standard.object(forKey: "selectedTags") as? Set<String> ?? Set<String>()
//                    }
            } else {
                HomeView()
                    .environmentObject(firestoreManager)
//                    .onAppear {
//                        if let data = UserDefaults.standard.object(forKey: "selectedTags") as? Set<String>,
//                           let category = try? JSONDecoder().decode([Tags].self, from: data) {
//                             print(category.tags)
//                        }
//                    }
//                    .onDisappear {
//                        if let encoded = try? JSONEncoder().encode(firestoreManager.selectedTags) {
//                            UserDefaults.standard.set(encoded, forKey: "selectedTags")
//                        }
//                    }
            }
        } else {
            OnboardingView()
                .environmentObject(firestoreManager)
                .onAppear {
                    UserDefaults.setFirstAccess(value: false)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
