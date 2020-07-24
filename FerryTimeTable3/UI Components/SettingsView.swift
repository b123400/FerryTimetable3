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
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Info", comment: ""))
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
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
