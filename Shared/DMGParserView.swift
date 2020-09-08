//
//  DMGParserView.swift
//  RE02
//
//  Created by Zerui Chen on 6/9/20.
//

import SwiftUI

struct DMGParserView: View {
    
    @State var fileURL: URL?
    @State var properties: [(String, Any)]?
    
    var body: some View {
        Group {
            if let properties = properties {
                PropertiesView(properties: properties)
            }
            else {
                FileDropView(accepting: "dmg", option: .trailer(512)) { url, data in
                    self.fileURL = url
                    self.properties = ReStruct.dmgStruct.parse(data).map {($0, $1)}
                }
            }
        }
        .navigationTitle(
            Text(fileURL.flatMap { $0.lastPathComponent} ?? "DMG Parser")
        )
    }
}

struct DMGParserView_Previews: PreviewProvider {
    static var previews: some View {
        DMGParserView()
    }
}
