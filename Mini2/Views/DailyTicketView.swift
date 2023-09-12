//
//  DailyTicketView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 11/09/23.
//

import SwiftUI

enum reroll {
    case rerolled
    case notRerolled
    case pickedPrevious
}

struct DailyTicketView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var rerollEnum: reroll = .notRerolled
    
    @State var previousTicket = ""
    @State var previousTags: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("StarsBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Image("Rosa")
                            .resizable()
                            .frame(width: 132, height: 285)
                    }
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Image("Verde")
                            .resizable()
                            .frame(width: 400, height: 450)
                        
                        Spacer()
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Collect your task!")
                            .foregroundColor(Color("white"))
                            .bold()
                            .font(.title)
                            .padding(.top)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Image("Machine")
                        .resizable()
                        .frame(width: 348, height: 420)
                    
                    Spacer()
                    
                    // Ticket
                    
                    VStack {
                        Text(firestoreManager.currentTicket)
                            .font(.callout)
                            .padding(.vertical)
                            .bold()
                        
                        HStack {
                            if rerollEnum != .pickedPrevious {
                                Button {
                                    if rerollEnum == .notRerolled {
                                        previousTicket = firestoreManager.currentTicket
                                        previousTags = firestoreManager.currentTicketTags
                                        firestoreManager.pickTicket()
                                        rerollEnum = .rerolled
                                    } else if rerollEnum == .rerolled {
                                        firestoreManager.currentTicket = previousTicket
                                        firestoreManager.currentTicketTags = previousTags
                                        rerollEnum = .pickedPrevious
                                    }
                                    
                                    print(rerollEnum)
                                } label: {
                                    HStack {
                                        if rerollEnum == .notRerolled {
                                            Image(systemName: "shuffle")
                                        }
                                        Text(rerollEnum == .notRerolled ? "New task!" : "Previous task")
                                            .bold()
                                    }
                                    .foregroundColor(Color("darkGray"))
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("darkGray"), lineWidth: 1)
                                    )
                                }
                                
                                Spacer()
                            }
                            

                            NavigationLink {
                                HomeView()
                            } label: {
                                Text("Collect")
                                    .foregroundColor(Color("white"))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 32)
                                    .background(Color("darkGray"))
                                    .cornerRadius(10)
                                    .bold()
                            }
                        }
                        .padding(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("white"))
                    .cornerRadius(5)
                }
                .padding(64)
                
                
            }
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .onAppear {
                if firestoreManager.currentTicket == "" {
                    firestoreManager.pickTicket()
                }
        }
        }
    }
}

struct DailyTicketView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(FirestoreManager())
    }
}
