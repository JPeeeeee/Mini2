//
//  FilterScreen.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 25/08/23.
//

import SwiftUI
import WrappingHStack

struct FilterScreen: View {
    
    @EnvironmentObject var selectedTags: SelectedTags
    
    var filtros: [String] = [
        "Praia",
        "Parque",
        "Academia",
        "Jogos",
        "Em casa",
        "Bar",
        "Sair com amigos",
        "Ao ar livre",
        "Livros",
        "Artesanato",
        "Fora deste mundo!"
    ]
    
    var body: some View {
        WrappingHStack (0..<filtros.count, id: \.self, alignment: .center) { i in
            FilterButton(label: filtros[i])
        }
    }
}

struct FilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
            .environmentObject(SelectedTags())
    }
}
