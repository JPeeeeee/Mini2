//
//  TaskView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 12/09/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var completedTask: Bool = false
    
    var body: some View {
        Group {
            if completedTask {
                CompletedTaskView()
            } else {
                TicketCardView(completed: $completedTask)
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
