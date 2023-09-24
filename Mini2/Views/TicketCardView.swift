//
//  TicketCardView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 13/09/23.
//

import SwiftUI

struct TicketCardView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager

    var body: some View {
        VStack {
            HStack {
                
                Text("Today's challenge:")
                    .foregroundColor(Color("white"))
                
                Spacer()
                
                if firestoreManager.rerollEnum != .pickedPrevious {
                    Button {
                        if firestoreManager.rerollEnum == .notRerolled {
                            firestoreManager.previousTicket = firestoreManager.currentTicket
                            firestoreManager.previousTicketTags = firestoreManager.currentTicketTags
                            firestoreManager.pickTicket()
                            firestoreManager.rerollEnum = .rerolled
                        } else if firestoreManager.rerollEnum == .rerolled {
                            firestoreManager.currentTicket = firestoreManager.previousTicket
                            firestoreManager.currentTicketTags = firestoreManager.previousTicketTags
                            firestoreManager.rerollEnum = .pickedPrevious
                            
                            UserDefaults.standard.set(true, forKey: "pickedPrevious")
                        }
                        UserDefaults.standard.set(firestoreManager.currentTicket, forKey: "currentTicket")
                        UserDefaults.standard.set(firestoreManager.currentTicketTags, forKey: "currentTicketTags")
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
            .padding(.bottom)
            
            TicketCard()
            
            ZStack {

                Image("Stars")
                    .resizable()
                    .scaledToFit()

                HStack {

                    Spacer()

                    Text("Finish your daily task to \n see your memory here!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("lightGray"))

                    Spacer()

                    Image("Polaroids")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 100)
            .background(Color("darkGray"))
            .cornerRadius(5)
        }
        .padding()
    }
}
