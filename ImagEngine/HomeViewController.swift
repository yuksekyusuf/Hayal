//
//  HomeViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/4/22.
//

import UIKit

class HomeViewController: UIViewController{
//MARK: - Properties
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ImagEngine")
        return imageView
    }()
    
    private let searchTextField = CustomTextField()
    private lazy var searchButton = CustomButton(backgroundColor: .systemYellow, title: "Get Images")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLogoImageView()
        configureTextField()
        configureButton()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .blue
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    private func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
                
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 78),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(pushResultsViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 125),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -125),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc private func pushResultsViewController() {
        let viewController = createTabBar()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func searchNavigationController() -> UINavigationController {
        let service = PhotoService()
        let imageService = ImageService()
        let interactor  = PhotosInteractor(service: service, imageService: imageService)
        let viewController = SearchViewController(interactor: interactor)
        interactor.viewController = viewController
        viewController.tag = searchTextField.text
        viewController.title = searchTextField.text
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func favoritesNavigationController() -> UINavigationController {
        let viewController = FavoritesViewController()
        viewController.title = "Favorites"
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: viewController)
    }

    private func createTabBar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .white
        tabbar.viewControllers = [searchNavigationController(), favoritesNavigationController()]
        return tabbar
    }
    

}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushResultsViewController()
        return true
    }
}
