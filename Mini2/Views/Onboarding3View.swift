//
//  Onboarding3View.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI
import WrappingHStack

struct Onboarding3View: View {
    
    @EnvironmentObject var firestoreMager: FirestoreManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var filtros1: [String] = [
        "Creativity",
        "Photography",
        "Music",
        "Writing",
        "Time perception & Mindfulness"
    ]
    
    var filtros2: [String] = [
        "Outside",
        "Productivity",
        "Exercise",
        "Self-Care",
        "Work",
        "Food",
        "No tech",
    ]
    
    var filtros3: [String] = [
        "With people",
        "With partner",
        "Pets",
    ]
    
    var body: some View {
        ZStack {
            
            
            ScrollView (showsIndicators: false){
                VStack (alignment: .leading){
                    HStack {
                        Rectangle()
                            .fill(Color("white").opacity(0.5))
                            .frame(maxHeight: 4)
                            .cornerRadius(100)
                            .padding(.horizontal, 4)
                        
                        Rectangle()
                            .fill(Color("white").opacity(0.5))
                            .frame(maxHeight: 4)
                            .cornerRadius(100)
                            .padding(.horizontal, 4)
                        
                        Rectangle()
                            .fill(Color("white"))
                            .frame(maxHeight: 8)
                            .cornerRadius(100)
                            .padding(.horizontal,4)
                    }
                    .padding(.horizontal, 100)
                    .padding(.top)
                    
                    Text("Let's start!")
                        .font(.title)
                        .bold()
                        .padding(.top, 32)
                    
                    Text("Choose the filters that intrest you the most so we can give you your first activity!")
                        .font(.callout)
                }
                .foregroundColor(Color("white"))
                
                
                VStack (alignment: .leading) {
                    Text("About...")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros1.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros1[i], backgroundColor: false)
                    }
                    
                    Text("Related to...")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros2.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros2[i], backgroundColor: false)
                    }
                    
                    Text("With...")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros3.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros3[i], backgroundColor: false)
                    }
                }
                .padding()
                .padding(.bottom, 64)
            }
            .padding(.horizontal)
            .background(Color("purple"))
            .onDisappear {
                firestoreMager.populatePossibleTickets()
            }
            .navigationBarBackButtonHidden()
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                            .font(.callout)
                            .bold()
                            .padding(.horizontal, 50)
                            .foregroundColor(Color("white"))
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("Start!")
                            .font(.callout)
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical)
                            .background(Color("white"))
                            .cornerRadius(100)
                            .foregroundColor(Color("darkGray"))
                    }
                }
                .padding(.vertical)
                .background(Color("purple"))
            }
            .padding(.horizontal, 32)
        }
    }
}

struct Onboarding3View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3View()
            .environmentObject(FirestoreManager())
    }
}