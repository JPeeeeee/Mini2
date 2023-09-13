//
//  MemoryView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI

struct MemoryView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        VStack {
            Image("Polaroid pink and blue")
                .resizable()
                .scaledToFit()
                .frame(width: 168, height: 173)
                .padding(.bottom)
                .padding(.top, 64)
            
            Text("There is nothing to see here yet")
                .bold()
                .font(.headline)
                .padding(.bottom, 4)
            
            Text("Finish your daily task to see \n your memories here!")
                .foregroundColor(Color("lightGray"))
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .foregroundColor(Color("white"))
    }
}

struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
