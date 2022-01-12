//
//  Image.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import Foundation

struct Photo: Codable {
    let id: String
    let owner: String
    let secret: String
    let farm: Int
    let title: String?
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
