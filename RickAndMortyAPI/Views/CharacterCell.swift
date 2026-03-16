//
//  CharacterCell.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 13/03/26.
//

import UIKit
import Alamofire

class CharacterCell: UITableViewCell {
    static let identifier = "CharacterCell"
    var onFavoriteTap: (() -> Void)?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ricksincolor"), for: .normal)
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: RickAndMortyCharacter, isFavorite: Bool) {
        nameLabel.text = character.name
        let imageName = isFavorite ? "rickconcolor" : "ricksincolor"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
        if let imageButton = UIImage(named: imageName) {
            let originalImage = imageButton.withRenderingMode(.alwaysOriginal)
            favoriteButton.setImage(originalImage, for: .normal)
        }
    }
    
    func configureFavorite(with favorite: FavoriteCharacter, isFavorite: Bool) {
        nameLabel.text = favorite.name
        let imageName = isFavorite ? "rickconcolor" : "ricksincolor"
        if let imageButton = UIImage(named: imageName) {
            let originalImage = imageButton.withRenderingMode(.alwaysOriginal)
            favoriteButton.setImage(originalImage, for: .normal)
        }
    }
    
    @objc func didTapFavorite() {
        onFavoriteTap?()
    }
}
