//
//  Onboarding2View.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI

struct Onboarding2View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image("onBoardingBlob2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 348, height: 420)
                        Spacer()
                        Image("onBoardingBlob3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 98, height: 132)
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Rectangle()
                            .fill(Color("white").opacity(0.5))
                            .frame(maxHeight: 4)
                            .cornerRadius(100)
                            .padding(.horizontal, 4)
                        
                        Rectangle()
                            .fill(Color("white"))
                            .frame(maxHeight: 8)
                            .cornerRadius(100)
                            .padding(.horizontal, 4)
                        
                        Rectangle()
                            .fill(Color("white").opacity(0.5))
                            .frame(maxHeight: 4)
                            .cornerRadius(100)
                            .padding(.horizontal,4)
                    }
                    .padding(.horizontal, 100)
                    .padding(.top)
                    
                    Spacer()
                    VStack {
                        HStack {
                            Image("polaroid")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 335, height: 324)
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
                
                VStack {
                    
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        
                        Text("How does it work?")
                            .font(.title)
                            .bold()
                        
                        Text("Memories are created from out-of-the-ordinary activities, and your job is to enjoy the experience! Here are the things we made for you:")
                            .font(.callout)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image(systemName: "flag.checkered")
                                .bold()
                            
                            Text("Get one activity per day!").font(.callout)
                        }
                        .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .bold()
                            Text("Choose your own filters for a unique experience.").font(.callout)
                        }
                        .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "pencil.tip.crop.circle")
                                .bold()
                            Text("Keep track of your memories and reflections!").font(.callout)
                        }
                        .padding(.vertical, 4)
                        
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
                                Onboarding3View()
                            } label: {
                                Text("Start!")
                                    .font(.callout)
                                    .bold()
                                    .padding(.horizontal, 50)
                                    .padding(.vertical)
                                    .background(Color("white"))
                                    .cornerRadius(100)
                            }
                        }
                    }
                    .foregroundColor(Color("darkGray"))
                    .padding(.horizontal, 64)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("pink"))
        }
        .navigationBarBackButtonHidden()
    }
}

struct Onboarding2View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding2View()
    }
}
