//
//  ImagePickerModel.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ImageViewPickerModel: ObservableObject {
    
    @Published private (set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func addUserTestPreference(text: String){
        guard let user else {return}
        
        Task{
            try await UserManager.shared.addUserTestPreference(userId: user.userId, testPreference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func deleteUserTestPreference(text: String){
        guard let user else {return}
        
        Task{
            try await UserManager.shared.deleteUserTestPreference(userId: user.userId, testPreference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
//    func addTestFavouriteMap(){
//        guard let user else {return}
//        let testMap = testMap(id: "1", title: "testMap", isSomething: true)
//        
//        Task{
//            try await UserManager.shared.addTestFavouriteMap(userId: user.userId, testMap: testMap)
//            self.user = try await UserManager.shared.getUser(userId: user.userId)
//        }
//    }
//
//    func deleteTestFavouriteMap(){
//        guard let user else {return}
//        let testMap = testMap(id: "1", title: "testMap", isSomething: true)
//
//        Task{
//            try await UserManager.shared.deleteTestFavouriteMap(userId: user.userId, testMap: testMap)
//            self.user = try await UserManager.shared.getUser(userId: user.userId)
//        }
//    }
    
    func deleteProfileImage(){
        guard let user, let path = user.imagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
    
    func saveProfileImage(image: UIImage){
        guard var user else { return }

        Task {
            let (path, name) = try await StorageManager.shared.saveImage(image: image, userId: user.userId)
            print("DEBUG2 SUCC")
            print("DEBUG2" + path)
            print("DEBUG2" + name)
            
            // Updates the local path for image deleting purposes
            user.setLocalImagePath(newPath: path)
            self.user = user

            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
    }
}
