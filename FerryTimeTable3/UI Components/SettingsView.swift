//
//  SettingsView.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/24.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsNav: View {
    var body: some View {
        NavigationView {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    @State var updating = false

    var body: some View {
        List {
            Section {
                Colour(text: NSLocalizedString("Slow ferry", comment: ""), colour: Color.green)
                Colour(text: NSLocalizedString("Fast ferry", comment: ""), colour: Color.red)
                Colour(text: NSLocalizedString("Optional ferry", comment: ""), colour: Color.yellow)
            }
            
            NavigationLink(destination: ReorderFerryView()) {
                Text(NSLocalizedString("Reorder routes", comment: ""))
            }
            
            Section(footer: Text("Last updated: \(lastUpdateString)")) {
                Button(action: {
                    self.updating = true
                    ModelManager.shared.saveRaws { _ in
                        self.updating = false
                    }
                }) {
                    Text(
                        self.updating
                            ? NSLocalizedString("Loading", comment: "")
                            : NSLocalizedString("Update timetable data", comment: "")
                    )
                }
                .disabled(self.updating)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Info", comment: ""))
    }
    
    var lastUpdateString: String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        if let d = ModelManager.shared.lastUpdate {
            return df.string(from: d)
        } else {
            return "never"
        }
    }
}

struct ReorderFerryView: View {
    @State var islands = ModelManager.shared.islands
    
    var body: some View {
        List {
            ForEach(islands) { island in
                Text(island.fullName)
            }
            .onMove(perform: onMove)
        }
        .listStyle(GroupedListStyle())
        .environment(\.editMode, .constant(.active))
        .navigationBarTitle(NSLocalizedString("Reorder routes", comment: ""))
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        islands.move(fromOffsets: source, toOffset: destination)
        ModelManager.shared.islands = islands
    }
}

struct Colour: View {
    let text: String
    let colour: Color

    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 10, height: 30)
                .cornerRadius(5)
                .border(Color.clear, width: 0)
                .foregroundColor(colour)
            Text(self.text)
        }
    }
}

struct SettingsNav_Previews: PreviewProvider {
    static var previews: some View {
        SettingsNav()
    }
}

struct Reorder_Previews: PreviewProvider {
    static var previews: some View {
        ReorderFerryView()
    }
}
