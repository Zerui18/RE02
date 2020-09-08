//
//  FileDropView.swift
//  RE02
//
//  Created by Zerui Chen on 6/9/20.
//

import SwiftUI

struct FileDropView: View {
    
    enum ReadOption {
        case full, header(Int), trailer(Int)
    }
    
    // MARK: Init
    init(accepting fileExtension: String, option: ReadOption, onDataReceived: @escaping (URL, Data) -> Void) {
        self.fileExtension = fileExtension
        self.readOption = option
        self.onDataReceived = onDataReceived
    }
    
    init() {
        onDataReceived = nil
        readOption = nil
        fileExtension = "dmg"
    }
    
    // MARK: State
    @State private var errorDescription: String?
    
    // MARK: Props
    private let fileExtension: String
    private let readOption: ReadOption!
    private let onDataReceived: ((URL, Data) -> Void)!
    
    // MARK: Body
    var body: some View {
        Text(".\(fileExtension)")
            .font(.system(size: 20, weight: .bold, design: .monospaced))
            .frame(width: 200, height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 25.0)
                    .strokeBorder(style:
                                    StrokeStyle(lineWidth: 3, lineCap: .round, dash: [15])
                    )
            )
            .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
                errorDescription = nil
                _ = providers[0].loadObject(ofClass: URL.self) { (url, error) in
                    guard error == nil else {
                        errorDescription = error!.localizedDescription
                        return
                    }
                    
                    guard url!.pathExtension == fileExtension else {
                        errorDescription = "\".\(url!.pathExtension)\" files are not accepted, please provide a \".\(fileExtension)\" file."
                        return
                    }
                    
                    // Callback with data.
                    do {
                        let data = try readFile(url: url!)
                        onDataReceived(url!, data)
                    }
                    catch (let readError) {
                        errorDescription = readError.localizedDescription
                    }
                }
                return true
            }
            .alert(item: $errorDescription) { (errorDescription) in
                Alert(title: Text("Error Opening File"),
                      message: Text(errorDescription))
            }
    }
    
    /// Effecient read file, returning only portion requested through ReadOption.
    private func readFile(url: URL) throws -> Data {
        let handle = try FileHandle(forReadingFrom: url)
        switch readOption {
        case .full:
            return handle.readDataToEndOfFile()
        case .header(let length):
            return handle.readData(ofLength: length)
        case .trailer(let length):
            let endIndex = handle.seekToEndOfFile()
            let trailerIndex = endIndex - UInt64(length)
            handle.seek(toFileOffset: trailerIndex)
            return handle.readDataToEndOfFile()
        case .none:
            fatalError()
        }
    }
}

struct FileDropView_Previews: PreviewProvider {
    static var previews: some View {
        FileDropView()
    }
}
