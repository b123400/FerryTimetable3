//
//  SettingsView.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/24.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SettingsNav: View {
    var body: some View {
        NavigationView {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    @State var updating = false
    @ObservedObject private var modelManager: ModelManager = ModelManager.shared

    var body: some View {
        List {
            Section {
                NavigationLink(destination: ReorderFerryView()) {
                    Text(NSLocalizedString("Reorder routes", comment: ""))
                }
            }
            
            Section(footer: !modelManager.hasLocationPermission ? Text(NSLocalizedString("With location permission, this app can show you more relevant informations", comment: "")) : Text("")) {
                NavigationLink(destination: HomeRouteSelectionView()) {
                    Text(NSLocalizedString("Home Route", comment: ""))
                    Spacer().layoutPriority(0)
                    if let i = modelManager.homeRoute {
                        Text(i.fullName).foregroundColor(.secondary).layoutPriority(5)
                    } else {
                        Text(NSLocalizedString("None", comment: "")).foregroundColor(.secondary)
                    }
                }
                
                if modelManager.selectedResidence != nil {
                    if !modelManager.hasLocationPermissionDetermined {
                        Button(action: { modelManager.requestLocationPermission() }, label: {
                            Text(NSLocalizedString("Grant location permission", comment: ""))
                        })
                    } else if modelManager.hasLocationPermission {
                        HStack {
                            Text(NSLocalizedString("Location Permission", comment: ""))
                            Spacer()
                            Image(systemName:"checkmark.circle.fill")
                                .renderingMode(.original)
                        }
                    } else {
                        HStack {
                            Text(NSLocalizedString("Location Permission", comment: ""))
                            Spacer()
                            Image(systemName:"xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        Toggle(isOn: .init(get: { modelManager.autoShowResidence }, set: { modelManager.autoShowResidence = $0 }), label: {
                            Text(NSLocalizedString("Auto show home route", comment: ""))
                        })
                    }
                }
            }
            
            Section(footer: Text(String(format: NSLocalizedString("Last updated: %@", comment: ""), lastUpdateString))) {
                Button(action: {
                    self.updating = true
                    Publishers.CombineLatest3(
                        ModelManager.shared.saveHolidays().mapError { $0 as Error },
                        ModelManager.shared.saveMetadatas(),
                        ModelManager.shared.saveRaws()
                    ).receive(subscriber: Subscribers.Sink(receiveCompletion: { completion in
                        self.updating = false
                    }, receiveValue: { _ in
                        
                    }))
                }) {
                    HStack {
                        Text(
                            self.updating
                                ? NSLocalizedString("Loading", comment: "")
                                : NSLocalizedString("Update timetable data", comment: "")
                        )
                        if #available(iOS 14.0, *) {
                            if self.updating {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
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

struct HomeRouteSelectionView: View {
    @State var islands = ModelManager.shared.islands
    
    @State var _selectedIsland: Island?
    func selectedIsland() -> Island? {
        self._selectedIsland ?? ModelManager.shared.homeRoute
    }
    
    var body: some View {
        List {
            Button(action: {
                ModelManager.shared.homeRoute = nil
                self._selectedIsland = nil
            }) {
                HStack {
                    Text(NSLocalizedString("None", comment: ""))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    if ModelManager.shared.homeRoute == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(islands) { island in
                Button(action: {
                    ModelManager.shared.homeRoute = island
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
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(NSLocalizedString("Home Route", comment: ""))
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
