//
//  FilterScreen.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 25/08/23.
//

import SwiftUI
import WrappingHStack

struct FilterScreen: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var filtros1: [String] = [
        "Criatividade",
        "Fotografia",
        "Música",
        "Escrita",
        "Percepção do tempo e mindfulness"
    ]
    
    var filtros2: [String] = [
        "Fora de casa",
        "Produtividade",
        "Atividades físicas",
        "Autocuidado",
        "Trabalho",
        "Comida",
        "Sem tech",
    ]
    
    var filtros3: [String] = [
        "Com pessoas",
        "Com companheiro(a)",
        "Pets",
    ]
    
    @State var offSet = 0.0
    
    var body: some View {
        
        ZStack {
            ScrollView {
                
                VStack (alignment: .leading) {
                    Text("Incentivo a:")
                        .padding()
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros1.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros1[i], backgroundColor: true)
                    }
                    
                    Text("Relacionado a:")
                        .padding()
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros2.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros2[i], backgroundColor: true)
                    }
                    
                    Text("Com quem?")
                        .padding()
                        .foregroundColor(.white)
                        .bold()
                    
                    WrappingHStack (0..<filtros3.count, id: \.self, alignment: .leading) { i in
                        FilterButton(label: filtros3[i], backgroundColor: true)
                    }
                }
                .padding(.bottom, 32)
                .padding()
                .offset(y: offSet)
                .onDisappear {
                    
                    firestoreManager.populatePossibleTickets()
                    
                    if !firestoreManager.selectedTags.isEmpty {
                        let arr = [String](firestoreManager.selectedTags)
                        
                        print("[FilterScreen] onDisappear: \(arr)")
                        
                        UserDefaults.standard.set(arr, forKey: "selectedTags")
                    }
                }
            }
            .background(.black)
            .navigationBarBackButtonHidden()
            
            
            VStack {
                
                HStack {
                    GeometryReader { geo in
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color("white"))
                                .bold()
                                .font(.title2)
                        }
                        .onAppear {
                            offSet = geo.size.height
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 30)
                .padding()
                .background(.black)
                
                
                Spacer()
            }
        }
    }
}

struct FilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
            .environmentObject(FirestoreManager())
        //        ContentView()
    }
}
