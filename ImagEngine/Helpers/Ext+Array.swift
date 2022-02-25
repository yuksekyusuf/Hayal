//
//  Ext+Array.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 2/10/22.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
