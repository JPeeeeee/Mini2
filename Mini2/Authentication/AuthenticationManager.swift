//
//  AuthenticationManager.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel{
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

@MainActor
final class AuthenticationManager: ObservableObject{
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Deletes user id and associated info
    func delete() async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        // Deletes firestore documents
        let dbUser = try await UserManager.shared.getUser(userId: user.uid)
        try await UserManager.shared.deleteDocument(user: dbUser)
        
//        // Deletes FireStorage data
//        try await StorageManager.shared.deleteData(userId: user.uid)
        
        try await user.delete()
    }
}

// MARK: SIGN IN WITH EMAIL

extension AuthenticationManager{
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassorword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassorword(password: String) async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
}

// MARK: SIGN IN ANONYMOUS

extension AuthenticationManager{
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
}
