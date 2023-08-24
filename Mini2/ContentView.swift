//
//  ContentView.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var randNum: Int = 0
    
    private var activities: [String] =
    [
        "Potato",
        "Yes",
        "No",
        "Sell",
        "Jump",
        "Easy Breezy"
    ]
    
    var body: some View {
        VStack{
            Text(activities[randNum]).font(.largeTitle)
            
            Button(action: {
                randNum = Int.random(in: 1..<activities.count)
            },
                   label: {
                Text("Generate Text")
            })
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
