//
//  TaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 12/09/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var previousTicket = ""
    @State var previousTags: [String] = []
    
    var body: some View {
        VStack {
            HStack {
                
                Text("Today's challenge:")
                    .foregroundColor(Color("white"))
                
                Spacer()
                
                if firestoreManager.rerollEnum != .pickedPrevious {
                    Button {
                        if firestoreManager.rerollEnum == .notRerolled {
                            previousTicket = firestoreManager.currentTicket
                            previousTags = firestoreManager.currentTicketTags
                            firestoreManager.pickTicket()
                            firestoreManager.rerollEnum = .rerolled
                        } else if firestoreManager.rerollEnum == .rerolled {
                            firestoreManager.currentTicket = previousTicket
                            firestoreManager.currentTicketTags = previousTags
                            firestoreManager.rerollEnum = .pickedPrevious
                            
                            UserDefaults.standard.set(true, forKey: "pickedPrevious")
                        }
                    } label: {
                        HStack {
                            if firestoreManager.rerollEnum == .notRerolled {
                                Image(systemName: "shuffle")
                            }
                            Text(firestoreManager.rerollEnum == .notRerolled ? "New task!" : "Previous task")
                                .bold()
                        }
                        .foregroundColor(Color("white"))
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("white"), lineWidth: 2)
                        )
                    }
                } else {
                    Image(systemName: "lock")
                        .bold()
                        .foregroundColor(Color("lightGray"))
                }
            }
            .frame(minHeight: 40)
            Spacer()
        }
        .padding()
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
