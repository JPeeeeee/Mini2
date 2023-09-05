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
    
    var body: some View {
        
        ScrollView {
            VStack (alignment: .leading) {
                Text("Incentivo a:")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                
                WrappingHStack (0..<filtros1.count, id: \.self, alignment: .leading) { i in
                    FilterButton(label: filtros1[i])
                }
                
                Text("Relacionado a:")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                
                WrappingHStack (0..<filtros2.count, id: \.self, alignment: .leading) { i in
                    FilterButton(label: filtros2[i])
                }
                
                Text("Com quem?")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                
                WrappingHStack (0..<filtros3.count, id: \.self, alignment: .leading) { i in
                    FilterButton(label: filtros3[i])
                }
            }
            .padding(.bottom, 32)
            .padding()
            .onDisappear {
                firestoreManager.populatePossibleTickets()
            }
        }
        .navigationBarBackButtonHidden()
        .background(.black)
    }
}

struct FilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
            .environmentObject(FirestoreManager())
        //        ContentView()
    }
}
