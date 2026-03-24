//
//  LogIn.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 23/03/26.
//

import UIKit


class LogIn: UIViewController {
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "Usuario"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Contraseña"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingrese su usuario"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingrese su contraseña"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Iniciar sesión", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(userLabel)
        view.addSubview(userTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(buttonCLicked), for: .touchUpInside)
        
        
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userLabel.heightAnchor.constraint(equalToConstant: 45),
            
            userTextField.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 20),
            userTextField.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor),
            userTextField.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            userTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 10),
            passwordLabel.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor),
            passwordLabel.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            passwordLabel.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor),
            loginButton.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            
        ])
    }
    
    @objc func buttonCLicked() {
        let charactersVC = ViewController()
        charactersVC.title = "Personajes"
        let nav1 = UINavigationController(rootViewController: charactersVC)
        nav1.tabBarItem = UITabBarItem(title: "Personajes", image: UIImage(systemName: "person.3"), tag: 0)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favoritos"
        let nav2 = UINavigationController(rootViewController: favoritesVC)
        nav2.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nav1, nav2]
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }

}
