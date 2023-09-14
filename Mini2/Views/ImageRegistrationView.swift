//
//  ImageRegistrationView.swift
//  Mini2
//
//  Created by Guilherme de Souza Barci on 13/09/23.
//

import SwiftUI

struct TestBaseView: View {
    @State private var showingSheet = false
    
    var body: some View {
        List{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .sheet(isPresented: $showingSheet) {
            ImageRegistrationView()
        }
        .navigationTitle("Test")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ImageRegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @State var memoryText: String = ""
    @State private var showConfirmationDialogue: Bool = false
    @State private var usingCamera: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var image: Image? = nil
    @State var uiImage: UIImage? = nil
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @StateObject private var viewModel = ImageViewPickerModel()
    @State private var url: URL? = nil

    var body: some View {
        NavigationStack{
            ZStack{
                Color("registrationGray")
                    .ignoresSafeArea()
                
                VStack{
                    Text("Review your past photos and reflect on the things you've experienced. What are those memories like, what makes you happy and what was memorable?")
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
                    
                    TextField("", text: $memoryText)
                        .placeholder(when: memoryText.isEmpty) {
                                Text("Today I thought about...").foregroundColor(Color("lightGray"))
                        }
                        .onSubmit {
                            print("Authenticating…")
                        }
                        .foregroundColor(Color("white"))
                        .padding()
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
                            }
                            
                            // Saves new image onto database
                            viewModel.saveProfileImage(image: uiImage!, text: memoryText)
                        }
                        
                        dismiss()
                    } label: {
                        HStack{
                            Text("Save")
                                .font(.title2)
                        }
                    }
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
                }
            }
        }
    }
}

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

struct ImageRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TestBaseView()
        }
    }
}
