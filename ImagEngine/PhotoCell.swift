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
    var interactor: PhotosInteractor?
    let imageService = ImageService()
    
    lazy var checkImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle")
        iv.tintColor = .systemBlue
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var highlightIndicator: UIView = {
        let view = UIView()
        view.frame = view.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            checkImage.isHidden = !isSelected
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(photo: Photo) {
        interactor?.setCell(photo: photo, photoImage: photoImage)
    }
    
    func setCell(justPhoto: Photo) {
        let url = justPhoto.url
        let cache = imageService.cache
        if let data = cache.get(key: url) {
            photoImage.image = UIImage(data: data)
        } else {
            imageService.downloadImage(from: url) { [weak self] data in
                guard let self = self else { return }
                guard let image = UIImage(data: data) else { return }
                self.photoImage.image = image
            }
        }
        
    }
    

    
    
    private func configure() {

        addSubview(photoImage)
        addSubview(highlightIndicator)
        addSubview(checkImage)
        
        highlightIndicator.isHidden = true
        checkImage.isHidden = true
//
        let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            photoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            photoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            photoImage.heightAnchor.constraint(equalTo: photoImage.widthAnchor)])
        
        NSLayoutConstraint.activate([
            highlightIndicator.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            highlightIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            highlightIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            highlightIndicator.heightAnchor.constraint(equalTo: highlightIndicator.widthAnchor)])
        
        
        NSLayoutConstraint.activate([
            checkImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            checkImage.heightAnchor.constraint(equalToConstant: 30),
            checkImage.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
