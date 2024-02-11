//
//  MarvelCharacters.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation

// MARK: - MarvelCharacters
struct MarvelCharacters {
  
    let id: Int
    let name, description: String
    let imageURl: String
    let resourceURI: String
    let comics, series: Stories?
    let stories: Stories?
    let events: Stories?
    let thumbnail: Thumbnail?

    
    init(_ character: Characters) {
        self.id = character.id ?? 0
        self.name = character.name ?? ""
        self.imageURl = "\(character.thumbnail?.path ?? "").\(character.thumbnail?.thumbnailExtension?.rawValue ?? "")"
        self.comics = character.comics 
        self.description = character.description ?? ""
        self.series = character.series
        self.resourceURI = character.resourceURI ?? ""
        self.events = character.events
        self.stories = character.stories
        self.thumbnail = character.thumbnail
    }
}
