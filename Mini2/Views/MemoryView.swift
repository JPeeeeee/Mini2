//
//  MemoryView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import SwiftUI

struct MemoryView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @StateObject private var viewModel = MemoryViewModel()
    
    var body: some View {
        VStack {
            let localMemories = UserManager.shared.getLocalMemories()
            if (!localMemories.dateCreated.isEmpty){
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                ForEach(0..<(localMemories.dateCreated.count), id: \.self){ index in
                        NavigationLink{
                            MemoryDelegate(uiImage: UserManager.shared.getLocalImages()[index], text: localMemories.associatedText[index])
                        } label: {
                            ZStack{
                                if (!UserManager.shared.getLocalImages().isEmpty){
                                    Image(uiImage: UserManager.shared.getLocalImages()[index])
                                        .resizable()
                                            .frame(width: 185, height:185, alignment: .center)
                                            .clipped()
                                            .padding()
                                
                                ZStack{
                                    Rectangle().frame(width: 55, height: 46, alignment: .topLeading)
                                        .foregroundColor(.white)
                                    
                                    let date = localMemories.dateCreated[index]
                                        let calendarDate = Calendar.current.dateComponents([.day], from: date)
                                        
                                        VStack (alignment: .center){
                                            Text(String(calendarDate.day!))
                                                .font(.system(size: 15))
                                            Text(date.monthMedium)
                                                .font(.system(size: 13))
                                        }
                                        .foregroundColor(.black)
                                    
                                }
                                .offset(x: -55, y: -55)
                                }
                            }
                        }
                    }
                }
            }
            
            else{
                Image("Polaroid pink and blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 168, height: 173)
                    .padding(.bottom)
                    .padding(.top, 64)
                
                Text("There is nothing to see here yet")
                    .bold()
                    .font(.headline)
                    .padding(.bottom, 4)
                
                Text("Finish your daily task to see \n your memories here!")
                    .foregroundColor(Color("lightGray"))
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .foregroundColor(Color("white"))
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}

extension Formatter {
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
}
extension Date {
    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
}
