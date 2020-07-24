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
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Info", comment: ""))
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
