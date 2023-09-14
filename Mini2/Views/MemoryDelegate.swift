//
//  MemoryDelegate.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 14/09/23.
//

import Foundation
import SwiftUI

struct MemoryDelegate: View {
    
    @State public var url: URL?
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack{
                if let url = self.url{
                    AsyncImage(url: url){ image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .clipped()
                    }
                }
            }
        }.ignoresSafeArea()
    }
}
