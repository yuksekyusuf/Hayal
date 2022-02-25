//
//  CellHeader.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 2/14/22.
//

import UIKit

class CellHeader: UICollectionReusableView {
    
    var label: UILabel = {
             let label: UILabel = UILabel()
             label.textColor = .white
             label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
             label.sizeToFit()
             return label
         }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
