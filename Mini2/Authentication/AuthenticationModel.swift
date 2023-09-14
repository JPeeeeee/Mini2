//
//  AuthenticationModel.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import Foundation

final class AuthenticationModel: ObservableObject {
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
