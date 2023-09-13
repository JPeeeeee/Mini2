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
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color("darkGray"))
        .cornerRadius(5)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geo in
                    ScrollView {
                        Group {
                            HStack {
                                Text("Collec")
                                    .font(.custom("hanoble", size: 32))
                                    .foregroundColor(Color("white"))
                                
                                Spacer()
                                
                                NavigationLink {
                                    FilterScreen()
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(Color("white"))
                                        .bold()
                                }
                            }
                            pickerView
                            
                            Button(action: {
                                Task {
                                    try await firestoreManager.uploadFilter(filters: ["Outside", "Time perception & Mindfullness"], ticketsArr: [
                                        
                                        "Go outside and think about everything you are seeing (trees, streets, animals, sky...). Make it a moment of self-connection, relaxation, and connection to the present.",
                                    ])
                                }
                            },
                                   label: {
                                Text("Send data")
                            })
                            .padding()
                        }
                        .padding()
                        
                        TabView(selection: $selected) {
                            TaskView().tag(1)
                                .environmentObject(firestoreManager)
                            
                            MemoryView().tag(2)
                                .environmentObject(firestoreManager)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(minHeight: geo.size.height)
                    }
                    .background(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            // apagar este onappear no final!!!!
            
            UserDefaults.standard.set(false, forKey: "pickedPrevious")
            UserDefaults.standard.set(firestoreManager.currentTicket, forKey: "currentTicket")
            UserDefaults.standard.set(firestoreManager.currentTicketTags, forKey: "currentTicketTags")
        }
    }
    
    var body2: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack{
                    Text(firestoreManager.currentTicket)
                        .font(.largeTitle)
                        .foregroundColor(Color("white"))
                    
                    ForEach(firestoreManager.currentTicketTags, id: \.self) { item in
                        Text(item)
                            .font(.largeTitle)
                            .foregroundColor(Color("white"))
                    }
                    
                    
                    NavigationLink {
                        FilterScreen()
                    } label: {
                        Text("Filter Screen")
                    }

                    
                    Button(action: {
                        if !firestoreManager.selectedTags.isEmpty {
                            firestoreManager.pickTicket()
                            print(firestoreManager.currentTicket)
                        } else {
                            print("n tem nada marcado cara")
                        }
                    },
                           label: {
                        Text("print data")
                    })
                    .padding()
                }
                .padding(.top, height + 16)
            }
            
            
            .frame(maxWidth: .infinity)
            .background(.black)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
