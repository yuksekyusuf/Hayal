//
//  Image.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import Foundation

struct Photo: Codable, Hashable {
    
    let uuid = UUID()
    private enum CodingKeys: String, CodingKey {case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily}
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    var url: String {
        "https://live.staticflickr.com/"+"\(self.server)/" + "\(self.id)" + "_\(self.secret)_q.jpg"
    }
    
}

extension Photo {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
