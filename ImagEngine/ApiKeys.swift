//
//  Keys.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/5/22.
//

import Foundation

class ApiKeys {
    let key = ["key":"5379a3eda00bd01a30d2c95543a55e77",
        "secret":"74e753fe68b0087f"
    ]
    
    let searchTerm: String = "Yusuf"
    
    let endpoint = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&api_key=5379a3eda00bd01a30d2c95543a55e77&tags='+cat+'&nojsoncallback=1"
}
