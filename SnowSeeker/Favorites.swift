//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Zach Mommaerts on 3/26/24.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directoryURL.appendingPathComponent(key)
        
        do {
            let savedData = try Data(contentsOf: filePath)
            if let savedString = String(data: savedData, encoding: .utf8) {
                let resortArray = savedString.components(separatedBy: ",")
                resorts = Set(resortArray)
            } else {
                resorts = []
            }
        } catch {
            resorts = []
            print("Unable to read the file")
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        let data = Data([String](resorts).joined(separator: ",").utf8)
        let url = URL.documentsDirectory.appending(path: key)

        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}
