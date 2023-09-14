//
//  CompletedTaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 13/09/23.
//

import SwiftUI

struct CompletedTaskView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("FinishedStars")
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    Text("Excelent work!")
                        .bold()
                    
                    Text("You finished your daily task")
                        .padding(.bottom)
                        .foregroundColor(Color("lightGray"))
                    
                    Image("Polaroid pink and blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168, height: 173)
                }
            }
            .background(Color("darkGray"))
            .cornerRadius(5)
            
            
            
            HStack {
                Text("Generated memory:")
                    .font(.title3)
                
                Spacer()
                
                Image(systemName: "square.and.pencil")
                    .font(.title2)
            }
            
            ZStack {
                Image("FinishedStars")
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    Text("You didn't add memories today")
                        .bold()
                    
                    Text("There's still time to \n register a new memory")
                        .padding(.bottom)
                        .foregroundColor(Color("lightGray"))
                        .multilineTextAlignment(.center)
                    
                    Button {
                        print("gerar memoria")
                    } label: {
                        Text("Add memory")
                            .padding(.horizontal, 32)
                            .padding(.vertical, 4)
                            .background(Color("white"))
                            .foregroundColor(Color("darkGray"))
                            .cornerRadius(10)
                            .bold()
                    }
                }
            }
            .background(Color("darkGray"))
            .cornerRadius(5)
            
            Spacer()
        }
        .foregroundColor(Color("white"))
        .padding()
    }
}

struct CompletedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTaskView()
    }
}
