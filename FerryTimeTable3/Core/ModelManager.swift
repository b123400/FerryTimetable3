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
    static let timetableUpdated = Notification.Name("timetableUpdated")
}

class ModelManager {
    static let shared = ModelManager()
    private init() {}
    
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

    private var _raws: [Route<TimeInterval>]?
    func getRaws() -> [Route<TimeInterval>] {
        if let r = _raws {
            return r
        }
        do {
            let fm = FileManager.default
            if fm.fileExists(atPath: self.rawsURL.path) {
                let data = try Data(contentsOf: self.rawsURL)
                let r = try JSONDecoder().decode([Route<TimeInterval>].self, from: data)
                _raws = r
                return r
            }
            let url = Bundle.main.url(forResource: "raws", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let r = try JSONDecoder().decode([Route<TimeInterval>].self, from: data)
            _raws = r
            return r
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    func saveRaws(callback: (([Route<TimeInterval>])-> Void)? = nil) {
        fetchRaws { (routes) in
            self._raws = routes
            NotificationCenter.default.post(Notification(name: .timetableUpdated))
            DispatchQueue.global().async {
                do {
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(routes)
                    let dataPath = self.rawsURL
                    try encoded.write(to: dataPath)
                } catch {
                    print(error.localizedDescription);
                }
            }
            callback?(routes)
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
    
    var lastUpdate: Date? {
        let url = self.rawsURL
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        do {
            let r = try url.resourceValues(forKeys: [.contentModificationDateKey])
            return r.contentModificationDate
        } catch {
            return nil
        }
    }
}

