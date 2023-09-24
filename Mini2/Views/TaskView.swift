//
//  TaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 12/09/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        Group {
            if firestoreManager.completedTask {
                CompletedTaskView()
            } else {
                TicketCardView()
            }
        }
        .task {
            print("DEBUG2 POPULATE")
            try! await UserManager.shared.populateLocalImages()
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
