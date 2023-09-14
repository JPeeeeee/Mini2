//
//  StorageManager.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 28/08/23.
//

import Foundation
import FirebaseStorage
import SwiftUI

final class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference ()
    
    private var imagesReference: StorageReference{
        storage.child("images")
    }
    
    private func userReference(userId: String) -> StorageReference{
        return storage.child("users").child(userId)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        return Storage.storage().reference(withPath: path)
    }
    
    func getUrlForImage(path: String) async throws -> URL {
        try await getPathForImage(path: path).downloadURL()
    }
    
    func getData(userId: String, path: String) async throws -> Data{
        //try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getImage(userId: String, path: String) async throws -> UIImage{
        let data = try await getData(userId: userId, path: path)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        return image
    }
    
    func saveImage (data: Data, userId: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata ()
        meta.contentType = "image/heic"
        
        let path = "\(UUID().uuidString).heic"
        
        print("DEBUG2 1")
        
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        print("DEBUG2 2")
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
                throw URLError(.badServerResponse)
        }
        
        print("DEBUG2 3")
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        guard let heicData = image.heic(compressionQuality: 0.2) else{
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await saveImage(data: heicData, userId: userId)
    }
    
    func saveImageData(data: Data, userId: String) async throws -> (path: String, name: String){
        // Compresses into heic
        let image = UIImage(data: data)
        guard let heicData = image?.heic(compressionQuality: 0.2) else{
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(data: heicData, userId: userId)
    }
    
    func deleteImage(path: String) async throws{
        try await getPathForImage(path: path).delete()
    }
}
