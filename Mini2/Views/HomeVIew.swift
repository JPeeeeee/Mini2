//
//  HomeView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var height: CGFloat = 0.0
    
    @State var selected = 1
    
    @State var navHeight = 0.0
    
    func getBinding() -> Binding<Int> {
        return Binding(get: { return selected }) { v in
            withAnimation {
                selected = v
            }
        }
    }
    
    var pickerView: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                HStack {
                    Rectangle()
                        .fill(Color("white"))
                        .frame(maxWidth: geo.size.width / 2)
                        .cornerRadius(5)
                }
                .offset(x: selected == 2 ? geo.size.width / 2 : 0)
                
                HStack {
                    Button {
                        withAnimation {
                            selected = 1
                        }
                    } label: {
                        Text("Task")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selected == 1 ? Color("darkGray") : Color("lightGray"))
                    }
                    
                    Button {
                        withAnimation {
                            selected = 2
                        }
                    } label: {
                        Text("Memories")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selected == 2 ? Color("darkGray") : Color("lightGray"))
                    }
                }
                .padding(.vertical)
            }
            .onAppear {
                height = geo.size.height
                print("pickerHeight: \(height)")
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color("darkGray"))
        .cornerRadius(5)
    }
    
    var navBar: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        if selected == 1 {
                            
                        } else {
                            withAnimation {
                                selected = 1
                            }
                        }
                    } label: {
                        Text("Collec")
                            .font(.custom("hanoble", size: 32))
                            .foregroundColor(Color("white"))
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink {
                        FilterScreen()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Color("white"))
                            .bold()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(.black)
            .overlay {
                GeometryReader { navReader in
                    Rectangle().fill(.clear)
                        .onAppear {
                            navHeight = navReader.size.height
                            print("navHeight: \(navHeight)")
                        }
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                    ScrollView (showsIndicators: false) {
                        pickerView
                            .padding()
                            .padding(.top, 60)
                        
                        Group {
                            if selected == 1 {
                                TaskView().tag(1)
                                    .transition(.move(edge: .leading))
                                    .environmentObject(firestoreManager)
                                
                            } else if selected == 2 {
                                MemoryView().tag(2)
                                    .transition(.move(edge: .trailing))
                                    .environmentObject(firestoreManager)
                            }
                        }
                        .frame(maxHeight: geo.size.height - navHeight - height - 60)
                    }
                    .background(.black)
                }
                
                navBar
                
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            
            UserDefaults.standard.set(firestoreManager.currentTicket, forKey: "currentTicket")
            UserDefaults.standard.set(firestoreManager.currentTicketTags, forKey: "currentTicketTags")
            
            firestoreManager.populatePossibleTickets()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
