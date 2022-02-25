//
//  ImageData.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import Foundation


struct Root: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let photo: [Photo]
}


