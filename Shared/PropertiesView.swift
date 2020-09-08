//
//  PropertiesView.swift
//  RE02
//
//  Created by Zerui Chen on 7/9/20.
//

import SwiftUI

struct PropertiesView: View {
    
    let properties: [(String,Any)]
    
    var body: some View {
        List(properties, id: \.0) { name, value in
            VStack(spacing: 0) {
                HStack {
                    Text(name)
                        .bold()
                        .frame(width: 150)
                    
                    Color(.tertiaryLabelColor)
                        .frame(width: 1)
                    
                    Text(String(describing: value))
                        .frame(maxWidth: .infinity)
                }
                .padding([.top, .bottom], 10)
                
                Divider()
            }
            .font(.system(.body, design: .monospaced))
        }
    }
}

struct PropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        PropertiesView(properties: [("a", 1), ("b", UUID()), ("a", 1), ("b", UUID()), ("a", 1), ("b", UUID()), ("a", 1), ("b", UUID()), ("a", 1), ("b", UUID())])
    }
}
