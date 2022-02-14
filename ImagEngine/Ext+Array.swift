//
//  Ext+Array.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 2/10/22.
//

import Foundation

extension Array {

    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}
