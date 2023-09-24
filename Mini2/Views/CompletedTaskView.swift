//
//  CompletedTaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 13/09/23.
//

import SwiftUI

struct CompletedTaskView: View {
    @State private var showingSheet = false
    @StateObject private var viewModel = MemoryViewModel()
    @Binding var localImages: [UIImage]
    
    var body: some View {
        VStack {
            ZStack {
                Image("FinishedStars")
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    Text("Excelent work!")
                        .bold()
                        .padding(.top)
                    
                    Text("You finished your daily task")
                        .padding(.bottom)
                        .foregroundColor(Color("lightGray"))
                    
                    Image("Polaroid pink and blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168, height: 173)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("darkGray"))
            .cornerRadius(5)
            
            HStack {
                Text("Generated memory:")
                    .font(.title3)
                
                Spacer()
                
                Button {
                    print("Modificar memória")
                    showingSheet = true
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                }
            }
            
            if let user = viewModel.user, Calendar.current.isDateInToday((user.userMemories?.dateCreated.last)!){
                if (!localImages.isEmpty){
                    Image(uiImage: localImages.last!)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .frame(maxWidth: 300)
                        .clipped()
                        .padding()
                }
            
                else if let urlString = user.imageUrl, let url = URL(string: urlString){
                    AsyncImage(url: url){ image in
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .frame(maxWidth: 300)
                            .clipped()
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .scaledToFill()
                            .frame(height: 250)
                            .frame(maxWidth: 300)
                            .padding()
                    }
                }
            }
            
            else{
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
                            showingSheet = true
                            
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
                .frame(maxWidth: .infinity)
                .background(Color("darkGray"))
                .cornerRadius(5)
            }
            
            Spacer()
        }
        .foregroundColor(Color("white"))
        .padding()
        .sheet(isPresented: $showingSheet) {
            ImageRegistrationView(localImages: self.$localImages)
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}
