//
//  TaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 12/09/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var localImages = [UIImage]()
    
    var body: some View {
        Group {
            if firestoreManager.completedTask {
                CompletedTaskView(localImages: self.$localImages)
            } else {
                TicketCardView(localImages: self.$localImages)
            }
        }
        .task {
            print("DEBUG2 POPULATE")
            localImages = try! await UserManager.shared.populateLocalImages()
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
