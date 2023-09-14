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
                            
                            else if let urlString = viewModel.user?.imageUrl, let url = URL(string: urlString){
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
            }
            // Saves picked image
            .onChange(of: uiImage, perform: { newValue in
                if let newValue{
                    
                    // Deletes previous image from database
                    if (viewModel.user?.imagePath != nil) {
                        viewModel.deleteProfileImage()
                    }
                    
                    // Saves new image onto database
                    viewModel.saveProfileImage(image: newValue)
                }
            })
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
