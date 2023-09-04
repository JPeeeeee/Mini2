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
    
    var filtros: [String] = [
        "Fora de casa",
        "Produtividade",
        "Atividades físicas",
        "Criatividade",
        "Fotografia",
        "Autocuidado",
        "Música",
        "Com pessoas",
        "Sobre percepção",
        "Trabalho",
        "Comida",
        "Sem tech",
        "Com companheiro(a)",
        "Pets",
        "Escrita"
    ]
    
    var body: some View {
        WrappingHStack (0..<filtros.count, id: \.self, alignment: .leading) { i in
            FilterButton(label: filtros[i])
        }
        .onDisappear {
            firestoreManager.populatePossibleTickets()
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
