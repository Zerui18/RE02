//
//  ContentView.swift
//  Shared
//
//  Created by Zerui Chen on 5/9/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            PagesList()
        }
    }
}

fileprivate struct PagesList: View {
    var body: some View {
        List {
            ListItem(title: "DMG Parser", destination: DMGParserView())
                .tag("DMG")
            
            ListItem(title: "Proc List", destination: ProcessListView())
                .tag("PL")
        }
    }
}

fileprivate struct ListItem<DstView: View>: View {
    
    init(title: String, destination: @autoclosure @escaping () -> DstView) {
        self.title = title
        self.destination = destination
    }
    
    let title: String
    let destination: () -> DstView
    
    var body: some View {
        NavigationLink(
            destination: destination())
            {
                Text(title)
                    .padding([.top, .bottom])
            }
        .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
