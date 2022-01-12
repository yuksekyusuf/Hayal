//
//  SearchViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

class SearchViewController: UIViewController {

    
    var searchTerm: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
          
        
    }
    
    
    private func getPhotos() {
        PhotoService.shared.getPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photosData):
                print("\(photosData.photos.photo[0])")
            case .failure(let error):
                print("\(error)")
                print("example")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
