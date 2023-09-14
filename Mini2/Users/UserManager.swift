//
//  UserManager.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct userMemory: Codable {
    let dateCreated: Date?
    var imagePath: String?
    let imageUrl: String?
    let associatedText: String
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let dateCreated: Date?
    let isTestBool: Bool?
    let userMemories: [userMemory]?
    var imagePath: String?
    let imageUrl: String?
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.isTestBool = false
        self.userMemories = nil
        self.imagePath = nil
        self.imageUrl = nil
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        dateCreated: Date? = nil,
        isTestBool: Bool? = nil,
        userMemories: [userMemory]? = nil,
        imagePath: String? = nil,
        imageUrl: String? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
        self.isTestBool = isTestBool
        self.userMemories = userMemories
        self.imagePath = imagePath
        self.imageUrl = imageUrl
    }
    
    mutating func setLocalImagePath(newPath: String){
        self.imagePath = newPath
    }
    
    // Allows for custom encoding and decoding
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
        case isTestBool = "is_test_bool"
        case userMemories = "user_memories"
        case imagePath = "image_path"
        case imageUrl = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isTestBool = try container.decodeIfPresent(Bool.self, forKey: .isTestBool)
        self.userMemories = try container.decodeIfPresent([userMemory].self, forKey: .userMemories)
        self.imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isTestBool, forKey: .isTestBool)
        try container.encodeIfPresent(self.userMemories, forKey: .userMemories)
        try container.encodeIfPresent(self.imagePath, forKey: .imagePath)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // Updates test bool
    func updateTestBool(userId: String, isTestBool: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isTestBool.rawValue : isTestBool
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // Updates image path and url
    func updateImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.imagePath.rawValue : path as Any,
            DBUser.CodingKeys.imageUrl.rawValue : url as Any
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // Updates entire document
    func updateDocument(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    func deleteDocument(user: DBUser) async throws {
        try await userDocument(userId: user.userId).delete()
    }
    
    func addUserTestPreference(userId: String, userMemory: userMemory) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.userMemories.rawValue : FieldValue.arrayUnion([userMemory])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func deleteUserTestPreference(userId: String, userMemory: userMemory) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.userMemories.rawValue : FieldValue.arrayRemove([userMemory])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
//    func addUserImage(userId: String, testMap: userImages) async throws {
//        guard let data = try? encoder.encode(testMap) else{
//            throw URLError(.badURL)
//        }
//
//        let dict: [String:Any] = [
//            DBUser.CodingKeys.testFavouriteMap.rawValue : data
//        ]
//
//        try await userDocument(userId: userId).updateData(dict)
//    }
//
//    func deleteUserImage(userId: String, testMap: userImages) async throws {
//        let data: [String:Any?] = [
//            DBUser.CodingKeys.testFavouriteMap.rawValue : nil
//        ]
//
//        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
//    }
}
