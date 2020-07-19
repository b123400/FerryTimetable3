//
//  Downloader.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/02.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import Alamofire

class ModelManager {
    static let shared = ModelManager()

    private init() {
        saveRaws()
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

    func getRaws() -> [Route<Int>] {
        do {
            let fm = FileManager.default
            if (fm.fileExists(atPath: self.rawsURL.absoluteString)) {
                let data = try Data(contentsOf: self.rawsURL)
                return try JSONDecoder().decode([Route<Int>].self, from: data)
            }
            let url = Bundle.main.url(forResource: "raws", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Route<Int>].self, from: data)
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

    func fetchRaws(callback: @escaping ([Route<Int>])-> Void) {
        AF.request("https://ferry.b123400.net/raws").responseDecodable(of: [Route<Int>].self) { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let routes):
                callback(routes)
            }
        }
    }
}

