//
//  OnboardingView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image("onBoardingBlob")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 348, height: 420)
                        Spacer()
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Rectangle()
                            .fill(Color("white"))
                            .frame(maxHeight: 8)
                            .cornerRadius(100)
                            .padding(.horizontal, 4)
                        
                        Rectangle()
                            .fill(Color("white").opacity(0.5))
                            .frame(maxHeight: 4)
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
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Image("typeWriter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 420)
                    }
                    
                    Spacer()
                }
                
                VStack {
                
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        
                        Text("Welcome!")
                            .font(.title)
                            .bold()
                        
                        Text("This will be your space to get away from the busy and monotonous routine and build daily memories")
                            .font(.callout)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image(systemName: "sun.max")
                                .bold()
                            Text("We'll help you to have memorable days!")
                                .font(.callout)
                        }
                        .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .bold()
                            Text("Get rid of your repetitive routine!")
                                .font(.callout)
                        }
                        .padding(.vertical, 4)
                        
                        HStack {

                            Spacer()
                            
                            NavigationLink {
                                Onboarding2View()
                            } label: {
                                Text("Continue")
                                    .font(.body)
                                    .bold()
                                    .padding(.horizontal, 64)
                                    .padding(.vertical)
                                    .background(Color("white"))
                                    .cornerRadius(100)
                            }
                            .padding(.vertical, 32)
                            Spacer()
                        }
                    }
                    .foregroundColor(Color("darkGray"))
                    .padding(.horizontal, 32)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("orange"))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
