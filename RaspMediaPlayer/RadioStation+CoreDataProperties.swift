//
//  RadioStation+CoreDataProperties.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 28/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RadioStation {

    @NSManaged var radioId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var address: String?

}
