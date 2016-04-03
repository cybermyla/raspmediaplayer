//
//  Album.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 27/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import Foundation

class Album {
    
    let name: String?
    let artist: String?
    let audioFiles: [AudioFile]?
    
    init(name: String, artist: String, audioFiles: [AudioFile]) {
        self.name = name
        self.artist = artist
        self.audioFiles = audioFiles
    }
    
}
