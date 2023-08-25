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
    @EnvironmentObject var selectedTags: SelectedTags
    
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
            if selectedTags.arr.contains(label) {
                selected = false
                selectedTags.arr.remove(label)
            } else {
                selected = true
                selectedTags.arr.insert(label)
            }
            
            print(selectedTags.arr)
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
            if selectedTags.arr.contains(label) {
                selected = true
            } else {
                selected = false
            }
        }
    }
}
