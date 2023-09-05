//
//  NavBar.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 05/09/23.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        VStack {
            HStack{
                Image("logo")
                    .padding(.top, 80)
                    .padding(.bottom)
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .padding(.top, 80)
                    .padding(.bottom)
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.horizontal, 8)
            .background(.black.opacity(0.75))
            .background(.ultraThinMaterial)
            .cornerRadius(14)
            .ignoresSafeArea()
            
            
            Spacer()
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
