//
//  PhotoCell.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/18/22.
//

import UIKit


class PhotoCell: UICollectionViewCell {
    
  
    //MARK: - Properties
    
    static let reuseID = "PhotoCell"
    var photoImage = PhotoImageView(frame: .zero)
    var interactor: PhotosInteractor!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(photo: Photo) {
        interactor.setCell(photo: photo, photoImage: photoImage)
    }
    

    
    
    private func configure() {

        addSubview(photoImage)
        let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            photoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            photoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            photoImage.heightAnchor.constraint(equalTo: photoImage.widthAnchor)])
    }
}
