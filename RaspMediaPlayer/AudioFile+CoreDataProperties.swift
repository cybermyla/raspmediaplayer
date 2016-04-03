//
//  AudioFile+CoreDataProperties.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 02/04/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AudioFile {

    @NSManaged var album: String?
    @NSManaged var artist: String?
    @NSManaged var fileId: NSNumber?
    @NSManaged var title: String?
    @NSManaged var track: String?

}
