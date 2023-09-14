//
//  MemoryViewModel.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 14/09/23.
//

import Foundation

@MainActor
final class MemoryViewModel: ObservableObject {
    
    @Published private (set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}
