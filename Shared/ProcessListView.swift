//
//  ProcessListView.swift
//  RE02
//
//  Created by Zerui Chen on 8/9/20.
//

import SwiftUI

struct ProcessListView: View {
    
    let refreshInterval = 1.0
    
    @State private var refreshTimer: Timer?
    @State private var procList: [Proc] = getProcList()
    @State private var filter = ""
    
    var body: some View {
        VStack {
            TextField("Search by name / pid", text: $filter)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 50)
                .padding([.leading, .trailing], 40)
            
            let filtered = filter.isEmpty ? procList :
                Int(filter) != nil ?
                    // By pid.
                    procList.filter {
                        String($0.pid).contains(filter)
                    } :
                    // By name.
                    procList.filter {
                        $0.name.lowercased().contains(filter.lowercased())
                    }
            
            List(filtered, id: \.pid) { proc in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(String(proc.pid))
                            .bold()
                            .frame(maxWidth: 80)
                        
                        Text(proc.name)
                    }
                    .padding([.top, .bottom], 10)
                    
                    Divider()
                }
                .font(.system(.body, design: .monospaced))
            }
        }
        .navigationTitle(Text("\(procList.count) Processes"))
        // Timer set & remove.
        .onAppear {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { (_) in
                procList = getProcList()
            }
        }
        .onDisappear {
            refreshTimer!.invalidate()
        }
    }
}

struct ProcessListView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessListView()
    }
}
