//
//  Downloader.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/02.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let islandsUpdated = Notification.Name("islandUpdated")
}

class ModelManager {
    static let shared = ModelManager()
    private init() {
        saveRaws()
    }
    
    private var _islands: [Island]?
    var islands: [Island] {
        get {
            if let i = _islands {
                return i
            }
            do {
                let data = try Data(contentsOf: self.islandsURL)
                let j = JSONDecoder()
                var islands = try j.decode([Island].self, from: data)
                
                // In case when we add new islands
                let newIslands = Island.allCases.filter { !islands.contains($0) }
                if !newIslands.isEmpty {
                    islands.append(contentsOf: newIslands)
                    self.islands = islands
                }
                return islands
            } catch {
                return Island.allCases
            }
        }
        set {
            _islands = newValue
            NotificationCenter.default.post(Notification(name: .islandsUpdated))
            DispatchQueue.global().async {
                do {
                    let j = JSONEncoder()
                    let data = try j.encode(newValue)
                    try data.write(to: self.islandsURL)
                } catch {
                    // whatever
                }
            }
        }
    }

    var documentURL: URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(fileURLWithPath: documentsDirectory)
        return docURL
    }

    var rawsURL: URL {
        self.documentURL.appendingPathComponent("raws.json")
    }
    
    var islandsURL: URL {
        self.documentURL.appendingPathComponent("islands.json")
    }

    func getRaws() -> [Route<TimeInterval>] {
        do {
            let fm = FileManager.default
            if fm.fileExists(atPath: self.rawsURL.path) {
                let data = try Data(contentsOf: self.rawsURL)
                return try JSONDecoder().decode([Route<TimeInterval>].self, from: data)
            }
            let url = Bundle.main.url(forResource: "raws", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Route<TimeInterval>].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    func saveRaws() {
        fetchRaws { (routes) in
            do {
                let encoder = JSONEncoder()
                let encoded = try encoder.encode(routes)
                let dataPath = self.rawsURL
                try encoded.write(to: dataPath)
            } catch {
                print(error.localizedDescription);
            }
        }
    }

    func fetchRaws(callback: @escaping ([Route<TimeInterval>])-> Void) {
        AF.request("https://ferry.b123400.net/raws").responseDecodable(of: [FailableJson<Route<TimeInterval>>].self) { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let routes):
                let okRoutes = routes.compactMap { (r) -> Route<TimeInterval>? in
                    switch r {
                        case .success(let x): return x
                        case .fail(_): return .none
                    }
                }
                callback(okRoutes)
            }
        }
    }
}

