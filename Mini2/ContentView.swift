//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var text: String = "DEBUG BASE"
    
    @StateObject var firestoreManager = FirestoreManager()
    
    var body: some View {
        if UserDefaults.isFirstAccess() == true {
            HomeView()
                .environmentObject(firestoreManager)
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
