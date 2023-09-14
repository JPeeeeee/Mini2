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
    @State public var text: String?
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack{
                ZStack{
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
                    VStack{
                        Spacer()
                        ZStack{
                            Text(text ?? "")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: geo.size.width, height: 200)
                                .background(.ultraThinMaterial)
                                            .saturation(0.0)
                                
                        }
                    }
                }
            }
        }.ignoresSafeArea()
    }
}
