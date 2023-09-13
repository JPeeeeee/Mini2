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
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @Binding var completed: Bool
    
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
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    Image(cardSet.image)
                        .resizable()
                        .scaledToFit()
                        .offset(x: -geo.size.width / 4)
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text(cardSet.image)
                                .font(.callout)
                                .foregroundColor(Color("white"))
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .padding()
                .background(cardSet.color)
                .cornerRadius(5)
                
                VStack {
                    Text(firestoreManager.currentTicket)
                        .padding(.vertical)
                    Button {
                        completed.toggle()
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
        }
    }
}

struct TicketCard_Previews: PreviewProvider {
    static var previews: some View {
        TicketCardView(completed: .constant(false))
            .environmentObject(FirestoreManager())
    }
}