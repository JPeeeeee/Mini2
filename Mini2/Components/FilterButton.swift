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
    
    var backgroundColor = true
    
    @State var selected: Bool = false
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    private var buttonColor: Color {
        if selected {
            return Color(uiColor: .white)
        } else {
            return Color(uiColor: .black)
        }
    }
    
    private var buttonColor2: Color {
        if selected {
            return Color(uiColor: .white)
        } else {
            return Color(uiColor: .white).opacity(0)
        }
    }
    
    private var textColor: Color {
        if selected {
            return Color(uiColor: .black)
        } else {
            return Color(uiColor: .white)
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
        } label: {
            Text(label)
                .foregroundColor(textColor)
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
                .background(backgroundColor == true ? buttonColor : buttonColor2)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.white, lineWidth: 1)
                )
                .padding(.vertical, 12)
                .padding(.horizontal, 2)
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

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
            .environmentObject(FirestoreManager())
//        ContentView()
    }
}
