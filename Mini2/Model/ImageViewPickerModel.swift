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
    
    func addUserMemory(userMemories: UserMemories){
        guard let user else {return}
        
        Task{
            try await UserManager.shared.addUserMemory(userId: user.userId, userMemories: userMemories)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func deleteUserMemory(userMemories: UserMemories){
        guard let user else {return}

        Task{
            try await UserManager.shared.deleteUserMemory(userId: user.userId, userMemories: userMemories)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func deleteProfileImage(){
        guard let user, let path = user.imagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
    
    func setMemory(index: Int, dateCreated: Date, imagePath: String, imageUrl: String, associatedText: String){
        guard var user else { return }
        
        user.setMemory(index: index, dateCreated: dateCreated, imagePath: imagePath, imageUrl: imageUrl, associatedText: associatedText)
    }
    
    func setLocalImagePathNil(){
        guard var user else { return }
        
        user.setLocalImagePath(newPath: "")
        self.user = user
    }
    
    func resaveText(text: String){
        guard var user else { return }
        Task {
            if let userM = user.userMemories {
                user.setMemory(index: (user.userMemories?.dateCreated.count)! - 1, dateCreated: (userM.dateCreated.last)!, imagePath: (userM.imagePath.last)!!, imageUrl: (userM.imageUrl.last)!!, associatedText: text)
            }
            
            let userM = UserManager.shared.getLocalMemories()
            
            UserManager.shared.setLocalMemoriesValue(index: userM.dateCreated.count - 1, dateCreated: (userM.dateCreated.last)!, imagePath: (userM.imagePath.last)!!, imageUrl: (userM.imageUrl.last)!!, associatedText: text)
            
            
            addUserMemory(userMemories: user.userMemories!)
        }
    }
    
    func saveProfileImage(image: UIImage, text: String){
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
            
            // If last memory was today just set new memory
            if(Calendar.current.isDateInToday((user.userMemories?.dateCreated.last)!)){
                // Sets today's memory
                user.setMemory(index: (user.userMemories?.dateCreated.count)! - 1, dateCreated: Date(), imagePath: path, imageUrl: url.absoluteString, associatedText: text)
            } else {
                user.addMemory(dateCreated: Date(), imagePath: path, imageUrl: url.absoluteString, associatedText: text)
            }
            
            
            UserManager.shared.addLocalMemory(dateCreated: Date(), imagePath: path, imageUrl: url.absoluteString, associatedText: text)
            
            addUserMemory(userMemories: user.userMemories!)
            
            try await UserManager.shared.updateImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
    }
}
