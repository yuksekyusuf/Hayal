//
//  PhotoImageView.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/18/22.
//

import UIKit


class PhotoImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "ImagEngine")
    let service = PhotoService()
//    let cache = NSCache<NSString, UIImage>()
    
//    lazy var checkImage: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "checkmark.circle")
//        iv.tintColor = .systemBlue
//        iv.clipsToBounds = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//
//    lazy var highlightIndicator: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(checkImage)
//        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        let padding: CGFloat = 8
//        NSLayoutConstraint.activate([
//            checkImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
//            checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            checkImage.heightAnchor.constraint(equalToConstant: 30),
//            checkImage.widthAnchor.constraint(equalToConstant: 30)
//        ])
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
       
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        backgroundColor = .white
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//    func downloadImage(from urlString: String) {
//        
//        let cacheKey = NSString(string: urlString)
//        
//        if let image = cache.object(forKey: cacheKey) {
//            self.image = image
//            return
//        }
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
//            guard let self = self else { return }
//            if error != nil { return }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
//            guard let data = data else { return }
//            guard let image = UIImage(data: data) else { return }
//            self.cache.setObject(image, forKey: cacheKey)
//            
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//        task.resume()
//    }
    
    
}
