//
//  AudioFile.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 23/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import Foundation

class AudioFile {
    let fileId: Int;
    let title: String
    let artist: String?
    let track: String?
    let album: String
    
    init(fileId: Int, title: String, artist: String, track: String, album: String) {
        self.fileId = fileId
        self.title = title
        self.artist = artist
        self.track = track
        self.album = album
    }
}