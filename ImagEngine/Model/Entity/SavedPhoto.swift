//
//  SavedPhoto.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 2/10/22.
//

import Foundation


struct SavedPhoto: Codable, Hashable  {
    let searchTag: String
    let url: String
}
