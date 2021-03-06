//
//  Downloader.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/02.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import Combine

class ModelManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = ModelManager()
    let locationManager = CLLocationManager()
    private override init() {
        super.init()
        locationManager.delegate = self
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
            self.objectWillChange.send()
            _islands = newValue
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
    
    private var _holidays: [Holiday]?
    var holidays: [Holiday] {
        get {
            if let h = _holidays {
                return h
            }
            do {
                let fm = FileManager.default
                if fm.fileExists(atPath: self.holidaysURL.path) {
                    let data = try Data(contentsOf: self.holidaysURL)
                    let h = try JSONDecoder().decode([Holiday].self, from: data)
                    _holidays = h
                    return h
                }
                let url = Bundle.main.url(forResource: "holidays", withExtension: "json")!
                let data = try Data(contentsOf: url)
                let h = try JSONDecoder().decode([Holiday].self, from: data)
                _holidays = h
                return h
            } catch {
                print(error.localizedDescription)
            }
            return []
        }
        set {
            _holidays = newValue
            DispatchQueue.global().async {
                do {
                    let j = JSONEncoder()
                    let data = try j.encode(newValue)
                    try data.write(to: self.holidaysURL)
                } catch {
                    // whatever
                }
            }
        }
    }
    
    var sharedUserDefaults: UserDefaults {
        get {
            UserDefaults(suiteName: "group.net.b123400.ferriestimetable")!
        }
    }
    
    var showsRichMenu: Bool {
        get {
            sharedUserDefaults.bool(forKey: "showsRichMenu")
        }
        set {
            sharedUserDefaults.set(newValue, forKey: "showsRichMenu")
            sharedUserDefaults.synchronize()
            self.objectWillChange.send()
        }
    }

    var documentURL: URL {
        let fileManager = FileManager.default
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.net.b123400.ferriestimetable")
        if let u = url {
            return u
        }
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(fileURLWithPath: documentsDirectory)
        return docURL
    }

    var rawsURL: URL {
        self.documentURL.appendingPathComponent("raws.json")
    }
    
    var metadatasURL: URL {
        self.documentURL.appendingPathComponent("metadatas.json")
    }
    
    var islandsURL: URL {
        self.documentURL.appendingPathComponent("islands.json")
    }
    
    var holidaysURL: URL {
        self.documentURL.appendingPathComponent("holidays.json")
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

    func saveRaws() -> AnyPublisher<[Route<TimeInterval>], Error> {
        fetchRaws()
            .mapError { $0 }
            .flatMap { routes in
                Future { promise in
                    self._raws = routes
                    self.objectWillChange.send()
                    DispatchQueue.global().async {
                        do {
                            let encoder = JSONEncoder()
                            let encoded = try encoder.encode(routes)
                            let dataPath = self.rawsURL
                            try encoded.write(to: dataPath)
                            promise(.success(routes))
                            self.objectWillChange.send()
                        } catch {
                            print(error.localizedDescription);
                            promise(.failure(error))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchRaws() -> Future<[Route<TimeInterval>], AFError> {
        Future { promise in
            AF.request("https://ferry.b123400.net/raws").responseDecodable(of: [FailableJson<Route<TimeInterval>>].self) { (response) in
                switch response.result {
                case .failure(let error):
                    print(error.localizedDescription)
                    promise(.failure(error))
                case .success(let routes):
                    let okRoutes = routes.compactMap { (r) -> Route<TimeInterval>? in
                        switch r {
                            case .success(let x): return x
                            case .fail(_): return .none
                        }
                    }
                    promise(.success(okRoutes))
                }
            }
        }
    }
    
    private var _metadata: [Island: Metadata]?
    func getMetadatas() -> [Island: Metadata] {
        if let m = _metadata {
            return m
        }
        do {
            let fm = FileManager.default
            if fm.fileExists(atPath: self.metadatasURL.path) {
                let data = try Data(contentsOf: self.metadatasURL)
                let m = try JSONDecoder().decode([String: Metadata].self, from: data)
                let islandMap = Island.toKeyedDict(strDict: m)
                _metadata = islandMap
                return islandMap
            }
            let url = Bundle.main.url(forResource: "metadatas", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let m = try JSONDecoder().decode([String: Metadata].self, from: data)
            let islandMap = Island.toKeyedDict(strDict: m)
            _metadata = islandMap
            return islandMap
        } catch {
            print(error.localizedDescription)
        }
        return [:]
    }

    func saveMetadatas() -> AnyPublisher<[Island: Metadata], Error> {
        fetchMetadatas()
            .mapError({ $0 })
            .flatMap { metadatas in
                Future { promise in
                    self.objectWillChange.send()
                    self._metadata = metadatas
                    DispatchQueue.global().async {
                        do {
                            let encoder = JSONEncoder()
                            let strMap = Island.fromKeyedDict(dict: metadatas)
                            let encoded = try encoder.encode(strMap)
                            let dataPath = self.metadatasURL
                            try encoded.write(to: dataPath)
                            promise(.success(metadatas))
                        } catch {
                            print(error.localizedDescription);
                            promise(.failure(error))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMetadatas() -> Future<[Island : Metadata], AFError> {
        Future { promise in
            AF.request("https://ferry.b123400.net/metadata").responseDecodable(of: [String : FailableJson<Metadata>].self) { (response) in
                switch response.result {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let metadata):
                    let okMetadatas = Island.toKeyedDict(strDict: metadata).compactMapValues { (failable:FailableJson<Metadata>) -> Metadata? in
                        switch failable {
                        case .fail(_): return .none
                        case .success(let x): return .some(x)
                        }
                    }
                    promise(.success(okMetadatas))
                }
            }
        }
    }
    
    func fetchHolidays() -> Future<[Holiday], AFError> {
        Future { promise in
            AF.request("https://ferry.b123400.net/holidays").responseDecodable(of: [Holiday].self) { (response) in
                switch response.result {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let holidays):
                    promise(.success(holidays))
                }
            }
        }
    }
    
    func saveHolidays()-> AnyPublisher<[Holiday], AFError> {
        fetchHolidays()
            .map { (holidays: [Holiday]) -> [Holiday] in
                self.holidays = holidays
                return holidays
            }
            .eraseToAnyPublisher()
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

    var homeRoute: Island? {
        get {
            if let s = sharedUserDefaults.string(forKey: "widgetIsland") {
                sharedUserDefaults.set(s, forKey: "homeRoute")
                sharedUserDefaults.removeObject(forKey: "widgetIsland")
                sharedUserDefaults.synchronize()
            }
            return sharedUserDefaults.string(forKey: "homeRoute").flatMap { Island(rawValue: $0) }
        }
        set {
            if newValue == nil {
                sharedUserDefaults.removeObject(forKey: "homeRoute")
            } else {
                sharedUserDefaults.set(newValue?.rawValue, forKey: "homeRoute")
            }
            sharedUserDefaults.synchronize()
            self.objectWillChange.send()
        }
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    var selectedResidence: Residence? {
        get {
            homeRoute.flatMap { Residence(island: $0) }
        }
    }
    var autoShowResidence: Bool {
        get {
            // Otherwise the detail view shows nothing anyway
            if UIDevice.current.userInterfaceIdiom == .pad {
                return true
            }
            return sharedUserDefaults.bool(forKey: "autoShowResidence")
        }
        set {
            sharedUserDefaults.set(newValue, forKey: "autoShowResidence")
            sharedUserDefaults.synchronize()
            self.objectWillChange.send()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.objectWillChange.send()
    }
    var hasLocationPermission: Bool {
        get {
            let status = CLLocationManager.authorizationStatus()
            return status == .authorizedWhenInUse || status == .authorizedAlways
        }
    }
    var hasLocationPermissionDetermined: Bool {
        get {
            return CLLocationManager.authorizationStatus() != .notDetermined
        }
    }
    var residentModeReady: Bool {
        get {
            self.selectedResidence != nil && hasLocationPermission
        }
    }

    func residenceDirectionWith(location: CLLocation) -> Direction? {
        if let residence = self.selectedResidence {
            if (residence.region.contains(location.coordinate)) {
                if (residence.regionIsPrimary) {
                    return .fromPrimary
                } else {
                    return .toPrimary
                }
            } else {
                if (residence.regionIsPrimary) {
                    return .toPrimary
                } else {
                    return .fromPrimary
                }
            }
        }
        return nil
    }
}

