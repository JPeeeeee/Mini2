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
    
    //   Tickets test
    let ticketsTest = [
        "lorem3",
        "ipsum3",
        "ipsum2",
        "fasfas3",
        "fdsafasdfa3",
        "porqewporpqe2w",
        "faca coisas legai2s",
        "fasjlkdfjlkasdjf2a"
    ]
    
    @State var selected = 1
    
    func getBinding() -> Binding<Int> {
        return Binding(get: { return selected }) { v in
            withAnimation {
                selected = v
            }
        }
    }
    
    var body2: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Picker("AA", selection: getBinding()) {
                        Text("Task").tag(1)
                        Text("Memory").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    
                    TabView(selection: $selected) {
                        Rectangle().fill(.red).tag(1)
                        
                        Rectangle().fill(.blue).tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(minHeight: 200)
                }
            }
        }
    }
    
    var body: some View {
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
                    
                    // debug only
                    Button(action: {
                        Task {
                            try await firestoreManager.uploadFilter(filters: ["Bar"], ticketsArr: ticketsTest)
                        }
                    },
                           label: {
                        Text("Send data")
                    })
                    .padding()
                    
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
