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
            if (viewModel.user?.userMemories?.imageUrl != nil){
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(0..<(viewModel.user?.userMemories?.imageUrl)!.count, id: \.self){ index in
                        NavigationLink{
                            MemoryDelegate(url: URL(string: (viewModel.user?.userMemories?.imageUrl[index])!), text: (viewModel.user?.userMemories?.associatedText[index])!)
                        } label: {
                            ZStack{
                                if let urlString = viewModel.user?.userMemories?.imageUrl[index], let url = URL(string: urlString){
                                    AsyncImage(url: url){ image in
                                        image.resizable()
                                            .frame(width: 185, height:185, alignment: .center)
                                            .clipped()
                                            .padding()
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 185, height:185, alignment: .center)
                                            .padding()
                                    }
                                }
                                
                                ZStack{
                                    Rectangle().frame(width: 55, height: 46, alignment: .topLeading)
                                        .foregroundColor(.white)
                                    
                                    if let date = viewModel.user?.userMemories?.dateCreated[index]{
                                        let calendarDate = Calendar.current.dateComponents([.day], from: date)
                                        
                                        VStack (alignment: .center){
                                            Text(String(calendarDate.day!))
                                                .font(.system(size: 15))
                                            Text(date.monthMedium)
                                                .font(.system(size: 13))
                                        }
                                        .foregroundColor(.black)
                                    }
                                }
                                .offset(x: -55, y: -55)
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
