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
            NavigationLink(destination: ReorderFerryView()) {
                Text(NSLocalizedString("Reorder routes", comment: ""))
            }
            NavigationLink(destination: WidgetRouteSelectionView()) {
                Text(NSLocalizedString("Widget", comment: ""))
                Spacer()
                Text(getWidgetIsland().fullName).foregroundColor(.secondary)
            }
            NavigationLink(destination: ResidentModeView()) {
                Text(NSLocalizedString("Resident Mode", comment: ""))
            }
            
            Section(footer: Text(String(format: NSLocalizedString("Last updated: %@", comment: ""), lastUpdateString))) {
                Button(action: {
                    self.updating = true
                    _ = ModelManager.shared.saveRaws()
                        .sink(receiveCompletion: { _ in
                            self.updating = false
                        }, receiveValue: { _ in })
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
            return NSLocalizedString("Never", comment: "Last update: never")
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

struct WidgetRouteSelectionView: View {
    @State var islands = ModelManager.shared.islands
    
    @State var _selectedIsland: Island?
    func selectedIsland() -> Island {
        self._selectedIsland ?? getWidgetIsland()
    }
    
    var body: some View {
        List(islands) { island in
            Button(action: {
                let userDefaults = sharedUserDefaults()
                userDefaults?.setValue(island.rawValue, forKey: "widget-island")
                userDefaults?.synchronize()
                self._selectedIsland = island
            }) {
                HStack {
                    Text(island.fullName)
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    if island == self.selectedIsland() {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Widget", comment: ""))
    }
}

struct ResidentModeView: View {
    @State private var enabled = false
    @ObservedObject private var modelManager: ModelManager = ModelManager.shared
    
    var body: some View {
        List {
            Section(header: Text(NSLocalizedString("Resident mode", comment: "")), footer: Text(NSLocalizedString("If you frequently use a route, you may find Resident Mode useful. It shows you the most relative information based on your location.", comment: ""))) {
                Toggle(isOn: .init(get: { modelManager.residentMode }, set: { modelManager.residentMode = $0 }), label: {
                    Text(NSLocalizedString("Enabled", comment: ""))
                })
            }
            
            if modelManager.residentMode {
                Section {
                    HStack {
                        Text(NSLocalizedString("Location Permission", comment: ""))
                        Spacer()
                        Image(systemName:"checkmark.circle.fill")
                            .renderingMode(.original)
                    }
                }
                Section(footer: Text(NSLocalizedString("Please enable Location in the Settings App to use Resident Mode", comment: ""))) {
                    HStack {
                        Text(NSLocalizedString("Location Permission", comment: ""))
                        Spacer()
                        Image(systemName:"xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                Section {
                    NavigationLink(destination: ResidenceSelectionView()) {
                        Text(NSLocalizedString("Home", comment: ""))
                        Spacer()
                        let residence = ModelManager.shared.selectedResidence
                        if let r = residence {
                            Text(r.rawValue).foregroundColor(.secondary)
                        } else {
                            Text(NSLocalizedString("None", comment: "")).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .animation(.easeInOut)
        .navigationBarTitle(NSLocalizedString("Resident Mode", comment: ""))
    }
}

struct ResidenceSelectionView: View {
    @ObservedObject private var modelManager: ModelManager = ModelManager.shared
    @State var _selectedPlace: Residence?
    func selectedPlace() -> Residence? {
        self._selectedPlace ?? ModelManager.shared.selectedResidence
    }
    
    var body: some View {
        List(Residence.allCases) { place in
            Button(action: {
                modelManager.selectedResidence = place
                self._selectedPlace = place
            }) {
                HStack {
                    Text(place.rawValue)
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    if place == self.selectedPlace() {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Resident Mode", comment: ""))
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

struct ResidentModeView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentModeView()
    }
}

func sharedUserDefaults()-> UserDefaults? {
    return UserDefaults(suiteName: "group.net.b123400.ferriestimetable")
}

func getWidgetIsland() -> Island {
    return sharedUserDefaults()?.string(forKey: "widget-island").flatMap { Island(rawValue: $0) } ?? Island.centralCheungChau
}
