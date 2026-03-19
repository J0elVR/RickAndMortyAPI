//
//  FavoritesViewController.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 15/03/26.
//

import UIKit
import SwiftUI
import CoreData

class FavoritesViewController: UIViewController {
    
    var favoriteCharacters: [FavoriteCharacter] = []
    var characters: [RickAndMortyCharacter] = []
    
    private let favoriteTableView: UITableView = {
        let table = UITableView()
        table.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
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
        view.backgroundColor = .white
        
        view.addSubview(favoriteTableView)
        view.addSubview(logoImage)
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            
            favoriteTableView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    func fetchFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        
        do {
            favoriteCharacters = try context.fetch(request)
            favoriteTableView.reloadData()
            
            if favoriteCharacters.isEmpty {
                showAlert(title: "Sin favoritos", message: "Podrás ver personajes una vez que agregues favoritos")
            }
        } catch {
            print("Error al obtener los personajes favorito \(error)")
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        let favCharacter = favoriteCharacters[indexPath.row]
        
        cell.configureFavorite(with: favCharacter, isFavorite: true)
        
        cell.onFavoriteTap = { [weak self] in
            self?.removeFavorite(favCharacter: favCharacter, at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fav = favoriteCharacters[indexPath.row]
            
            let characterSelected = RickAndMortyCharacter(
                id: Int(fav.id),
                name: fav.name ?? "",
                status: fav.status ?? "", 
                species: fav.species ?? "",
                gender: fav.gender ?? "",
                image: fav.image ?? ""
            )
            
            let detailCharacterView = DetailCharacterView(character: characterSelected)
            let hostingController = UIHostingController(rootView: detailCharacterView)
            
            navigationController?.pushViewController(hostingController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func removeFavorite(favCharacter: FavoriteCharacter, at indexPath: IndexPath) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appdelegate.persistentContainer.viewContext
        
        let characterName = favCharacter.name ?? "Personaje"
        showAlert(title: "Eliminado", message: "Se ha eliminado \(characterName) de favoritos")
        context.delete(favCharacter)
        do {
            try? context.save()
            
            self.favoriteCharacters.remove(at: indexPath.row)
            favoriteTableView.performBatchUpdates({
                favoriteTableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
    
        } catch {
            print("Error al borrar: \(error)")
        }

    }
}
