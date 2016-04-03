//
//  AlbumDetailViewController.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 27/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    var album: Album!
    
    let apiManager = ApiManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func playTapped(sender: AnyObject) {
        let audioFile = album.audioFiles![tableView.indexPathForSelectedRow!.row]
        if let fileId = audioFile.fileId as? Int {
            apiManager.playSong(fileId)
        }
    }
    
    @IBAction func pauseTapped(sender: AnyObject) {
        apiManager.pauseSong()
    }
    
    @IBAction func stopTapped(sender: AnyObject) {
        apiManager.stopSong()
    }
    
    override func viewDidLoad() {
        self.title = album.name
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = album?.name
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: Table View Data Source

extension AlbumDetailViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.album?.audioFiles?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.AudioFileCell, forIndexPath: indexPath) as! AudioFileCell
        cell.configureForAudioFileCell(album!.audioFiles![indexPath.row])
        return cell
    }
}

// Mark: Table View Delegate

extension AlbumDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //delegate?.menuItemSelected(MenuItem(rawValue: indexPath.row)!)
    }
    
}

class AudioFileCell: UITableViewCell {
    
    @IBOutlet weak var songName: UILabel!
    
    func configureForAudioFileCell(audioFile: AudioFile) {
        songName.text = audioFile.title
    }
}


