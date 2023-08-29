//
//  FilterButton.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 25/08/23.
//

import SwiftUI
import WrappingHStack

struct FilterButton: View {
    
    var label: String = ""
    
    @State var selected: Bool = false
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    private var buttonColor: Color {
        if selected {
            return .black
        } else {
            return .white
        }
    }
    
    private var textColor: Color {
        if selected {
            return .white
        } else {
            return .black
        }
    }
    
    var body: some View {
        Button {
            if firestoreManager.selectedTags.contains(label) {
                selected = false
                firestoreManager.remove(filter: label)
            } else {
                selected = true
                firestoreManager.insert(filter: label)
            }
            
            print(firestoreManager.selectedTags)
        } label: {
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(textColor)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(buttonColor)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.black, lineWidth: 4)
                )
                .padding()
                .buttonStyle(.bordered)
        
        }
        .onAppear {
            if firestoreManager.selectedTags.contains(label) {
                selected = true
            } else {
                selected = false
            }
        }
    }
}
