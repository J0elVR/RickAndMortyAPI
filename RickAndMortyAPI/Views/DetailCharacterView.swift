//
//  DetailCharacterView.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 15/03/26.
//

import SwiftUI

struct DetailCharacterView: View {

    let character: RickAndMortyCharacter

    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView().tint(.green)
                    }
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)

                    VStack(alignment: .leading, spacing: 20) {
                        Text(character.name)
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                        Divider().background(Color.white.opacity(0.5))
                        DetailRow(icon: "heart.fill", label: "Estado", value: character.status, color: character.status == "Alive" ? .red : .black)
                        DetailRow(icon: "person.fill", label: "Especie", value: character.species, color: .blue)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.7))
                    Text(value)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
        }
}
