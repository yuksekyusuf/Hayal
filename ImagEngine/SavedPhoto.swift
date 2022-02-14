//
//  SavedPhoto.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 2/10/22.
//

import Foundation


struct SavedPhoto: Codable, Hashable {
    
    let id = UUID()
    private enum CodingKeys: String, CodingKey {case searchTag, url}
    let searchTag: String
    let url: String
}

extension SavedPhoto {
    static func ==(lhs: SavedPhoto, rhs: SavedPhoto) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
