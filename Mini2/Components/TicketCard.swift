//
//  TicketCard.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 12/09/23.
//

import SwiftUI

struct CardSet {
    let image: String
    let color: Color
}

struct TicketCard: View {
    
    @State private var showingSheet = false
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    private var cardSet: CardSet {
        
        var tag = ""
        
        if !firestoreManager.currentTicketTags.isEmpty {
            tag = firestoreManager.currentTicketTags[0]
        } else {
            tag = "Time perception & Mindfulness"
        }
        
        let blueTags = [
            "Creativity",
            "No tech",
            "Work"
        ]
        
        let pinkTags = [
            "Reading",
            "Photography",
            "Productivity"
        ]
        
        let purpleTags = [
            "Music",
            "Writing"
        ]
        
        let yellowTags = [
            "Self-Care",
            "Romantic"
        ]
        
        let orangeTags = [
            "Time perception & Mindfulness",
            "Physical activity",
            "Outside"
        ]
        
        let greenTags = [
            "Pets",
            "Food",
            "With people"
        ]
        
        if blueTags.contains(tag) {
            return CardSet(image: tag, color: Color("blue"))
        } else if pinkTags.contains(tag) {
            return CardSet(image: tag, color: Color("pink"))
        } else if purpleTags.contains(tag) {
            return CardSet(image: tag, color: Color("purple"))
        } else if yellowTags.contains(tag) {
            return CardSet(image: tag, color: Color("yellow"))
        } else if orangeTags.contains(tag) {
            return CardSet(image: tag, color: Color("orange"))
        } else if greenTags.contains(tag) {
            return CardSet(image: tag, color: Color("green"))
        }
        
        return CardSet(image: tag, color: Color("yellow"))
    }
    
    @State var width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                HStack {
                    Image(cardSet.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width/2, minHeight: 200)
                    
                    Spacer()
                }
                
                HStack {
                    
                    VStack {
                        Text(cardSet.image)
                            .font(.callout)
                            .foregroundColor(Color("white"))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(cardSet.color)
            .cornerRadius(5)
            
            VStack {
                Text(firestoreManager.currentTicket)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                    .foregroundColor(Color("darkGray"))
                Button {
                    showingSheet = true
                  print("show modal")
                } label: {
                    Text("Complete task")
                        .padding(.horizontal, 32)
                        .padding(.vertical, 4)
                        .background(.black)
                        .foregroundColor(Color("white"))
                        .cornerRadius(10)
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("white"))
        }
        .background(Color("white"))
        .cornerRadius(5)
        .sheet(isPresented: $showingSheet) {
            ImageRegistrationView()
        }
    }
}

struct TicketCard_Previews: PreviewProvider {
    static var previews: some View {
//        TicketCard(completed: .constant(false))
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
