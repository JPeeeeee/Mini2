//
//  ImageRegistrationView.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import SwiftUI

struct ImageRegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @State var memoryText: String = ""
    @State private var showConfirmationDialogue: Bool = false
    @State private var usingCamera: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var image: Image?
    @State var uiImage: UIImage?
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @StateObject private var viewModel = ImageViewPickerModel()
    @State private var url: URL?
    private var localImages = UserManager.shared.getLocalImages()

    var body: some View {
        NavigationStack{
            ZStack{
                Color("registrationGray")
                    .ignoresSafeArea()
                
                VStack{
                    Text(firestoreManager.currentTicket)
                        .padding()
                        .foregroundColor(.white)
                    
                    Button{
                        self.showConfirmationDialogue = true
                    } label: {
                        // Shows Image
                        ZStack{
                            if image != nil {
                                image?.resizable()
                                    .scaledToFill()
                                    .frame(height:250, alignment: .center)
                                    .cornerRadius(20)
                                    .clipped()
                                    .padding()
                            }
                            
                            else if let urlString = viewModel.user?.imageUrl, let url = URL(string: urlString), Calendar.current.isDateInToday((viewModel.user?.userMemories?.dateCreated.last)!){
                                AsyncImage(url: url){ image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(height:250, alignment: .center)
                                        .cornerRadius(20)
                                        .clipped()
                                        .padding()
                                        .tint(.red)
                                } placeholder: {
                                    ProgressView()
                                        .scaledToFill()
                                        .frame(height:250, alignment: .center)
                                        .cornerRadius(20)
                                        .padding()
                                }
                            }
                            
                            else{
                                Rectangle()
                                    .padding()
                                    .foregroundColor(Color("lightGray"))
                                    .frame(height: 250)
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color("registrationGray"))
                                    .font(.title)
                                    .bold()
                            }
                        }
                    }
                    .confirmationDialog("Select Photo", isPresented: $showConfirmationDialogue){
                        Button("Photo Library") {
                            self.showImagePicker = true
                            self.usingCamera = false
                        }
                        
                        Button("Camera") {
                            self.showImagePicker = true
                            self.usingCamera = true
                        }
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        ImagePicker(isShown: $showImagePicker, image: $image, uiImage: $uiImage, usingCamera: usingCamera)
                    }
                    
                    TextField("", text: $memoryText, axis: .vertical)
                        .placeholder(when: memoryText.isEmpty) {
                                Text("Today...")
                                    .foregroundColor(Color("lightGray"))
                        }
                        .lineLimit(4...)
                        .padding()
                        .padding(.vertical, 16)
                        .foregroundColor(Color("white"))
                    Spacer()
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        firestoreManager.completedTask = true
                        UserDefaults.standard.set(firestoreManager.completedTask, forKey: "completedTask")
                        
                        if (uiImage != nil){
                            // Deletes previous image from database / Skips deletion if it's a new day
                            if (viewModel.user?.imagePath != nil && Calendar.current.isDateInToday((viewModel.user?.userMemories?.dateCreated.last)!)) {
                                viewModel.deleteProfileImage()
                                UserManager.shared.deleteLocalImage()
                                UserManager.shared.deleteLocalMemory()
                            }
                            
                            // Saves new image onto database
                            viewModel.saveProfileImage(image: uiImage!, text: memoryText)
                            
                            // Saves to local
                            UserManager.shared.appendLocalImage(uiImage: uiImage!)
                        }
                        
                        else {
                            viewModel.resaveText(text: memoryText)
                        }
                        
                        dismiss()
                    } label: {
                        HStack{
                            Text("Save")
                                .font(.title2)
                        }
                    }
                    .disabled(image == nil || memoryText == "")
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Add New Memory")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button{
                            dismiss()
                        } label: {
                            HStack{
                                Image(systemName: "chevron.left")
                                
                                Text("Back")
                            }
                            .font(.title2)
                        }
                    }
                }
            }
            // Loads user and saves image url when view is Opened
            .task {
                print("DEBUG2 TASK")
                try? await viewModel.loadCurrentUser()
                                
                if let path = viewModel.user?.imagePath {
                    let url = try? await StorageManager.shared.getUrlForImage(path: path)
                    self.url = url
                }
                
                // If the user has no memories, create an empty memory
                if viewModel.user?.userMemories == nil {
                    let userMemory = UserMemories(dateCreated: [Date()], imagePath: [""], imageUrl: [""], associatedText: [""])
                    viewModel.addUserMemory(userMemories: userMemory)
                }
                
                // Has memories and it's on the same day
                else if (Calendar.current.isDateInToday((viewModel.user?.userMemories?.dateCreated.last)!)){
                    memoryText = (viewModel.user?.userMemories?.associatedText.last)!
                    if(!localImages.isEmpty){
                        self.image = Image(uiImage: localImages.last!)
                    }
                }
            }
        }
    }
}

//struct ImageRegistrationPreview: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            ImageRegistrationView(localImages: Binding.constant([UIImage]()))
//        }
//    }
//}

// Used for the TextField placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
