//
//  ViewController.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 12/03/26.
//

import UIKit
import SwiftUI
import Alamofire
import CoreData
import Network

class ViewController: UIViewController, UITableViewDelegate {
    
    var isPaginating = false
    var nextPage: String? = nil
    var characters : [RickAndMortyCharacter] = []
    let networkManager = NetworkManager()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "RickAndMortyLogo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
            guard let self = self else { return }
            
            if NetworkMonitor.shared.isConnected {
                self.fetchData()
            } else {
                self.showOfflineAlert()
            }
        }
        
        view.addSubview(logoImage)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
        
        //SearchBar
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personaje"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //Function to attach the data
    private func fetchData() {
        isPaginating = true
        networkManager.getData { [weak self] result in
            DispatchQueue.main.async {
                self?.isPaginating = false
                switch result {
                case .success(let response):
                    self?.characters = response.results
                    self?.nextPage = response.info.next
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error: \(error)")
                    self?.characters = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func loadMoreCharacters() {
        guard !isPaginating, let url = nextPage else { return }
        
        isPaginating = true
        networkManager.getData(url: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.isPaginating = false
                switch result {
                case .success(let response):
                    self?.nextPage = response.info.next
                    self?.characters.append(contentsOf: response.results)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func showOfflineAlert() {
        let retryConectionAction = UIAlertAction(title: "Reintentar conexión", style: .default) { _ in
            if NetworkMonitor.shared.isConnected {
                self.fetchData()
            } else {
                self.showOfflineAlert()
            }
        }
            
        let settingsAction = UIAlertAction(title: "Abrir configuración", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        let favoritesSectionAction = UIAlertAction(title: "Ver mis favoritos", style: .default) { _ in
            self.tabBarController?.selectedIndex = 1
        }
        
        showAlert(title: "Sin conexión", message: "No tienes conexión  internet", action: [retryConectionAction, settingsAction, favoritesSectionAction])
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        let favoriteStatus = isFavorite(id: character.id)
        cell.configure(with: character, isFavorite: favoriteStatus)
        cell.onFavoriteTap = { [weak self] in
            self?.saveToFavorites(character: character)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterSelected = characters[indexPath.row]
        let detailCharacterView = DetailCharacterView(character: characterSelected)
        let hostingController = UIHostingController(rootView: detailCharacterView)
        hostingController.title = characterSelected.name
        navigationController?.pushViewController(hostingController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characters.count - 1 {
            loadMoreCharacters()
        }
    }
    
    //Function to save data in core data
    func saveToFavorites(character: RickAndMortyCharacter) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        //Looking for duplicates with id
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
        
        //Creating new favorite object type and Save
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteAdded = results.first {
                context.delete(favoriteAdded)
                showAlert(title: "Eliminado", message: "Se ha eliminado \(character.name) de favoritos")
                print("\(character.name) eliminado de favoritos")
            } else {
                let favorite = FavoriteCharacter(context: context)
                favorite.id = Int64(character.id)
                favorite.name = character.name
                favorite.image = character.image
                favorite.species = character.species
                favorite.status = character.status
                favorite.gender = character.gender
                showAlert(title: "Añadido", message: "Se ha añadido \(character.name) a favoritos")
                print("\(character.name) añadido a favoritos")
            }
            try context.save()
        } catch {
            print("Error en favoritos: \(error)")
        }
    }
    
    //Validate the favorite character in the table
    func isFavorite(id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        networkManager.getData(name: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.characters = response.results
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("No se encontró ningún personaje con ese nombre: \(error)")
                    self?.characters = []
                    self?.tableView.reloadData()
                    
                }
            }
        }
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetchData()
    }
        
}

extension UIViewController {
    public func showAlert(title: String, message: String, action: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if action.isEmpty {
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        } else {
            action.forEach { alertController.addAction($0) }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
