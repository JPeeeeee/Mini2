//
//  TicketsRepository.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 29/08/23.
//

import Foundation
import Combine



class TicketsRepository: ObservableObject {
    @Published
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        cancellables.append(contentsOf: [
            
        ])
    }
}
