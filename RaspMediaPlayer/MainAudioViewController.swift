//
//  MainAudioViewController.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 23/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import UIKit


class MainAudioViewController: UIViewController, ApiManagerDelegate {
    
    var audioFiles = [AudioFile]()
    var albums = [Album]()
    
    var apiManager = ApiManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        self.title = "Albums"
        getAudioFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        let audioFile = audioFiles[tableView.indexPathForSelectedRow!.row]
        if let fileId = audioFile.fileId as? Int {
            apiManager.playSong(fileId)
        }
    }
    @IBAction func stopTapped(sender: AnyObject) {
        apiManager.stopSong()
    }
    @IBAction func pauseTapped(sender: AnyObject) {
        apiManager.pauseSong()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    func getAudioFiles() {
        apiManager.delegate = self
        apiManager.getAudioFiles()
    }
    
    func getAlbums() {
        let fetchedResults = AudioFile.MR_fetchAllGroupedBy("album", withPredicate: nil, sortedBy: "album", ascending: true)
        if let sections = fetchedResults.sections {
            for section in sections {
                let name = section.name
                let audiofiles = section.objects as! [AudioFile]
                var artist = ""
                if audiofiles.count > 0 {
                    artist = audiofiles[0].artist!
                }
                albums.append(Album(name: name, artist: artist, audioFiles: audiofiles))
            }
        }
    }
    
    func dataDownloadFinished(sender: ApiManager) {
        getAlbums()
        self.tableView.reloadData()
    }
}


// MARK: Table View Data Source

extension MainAudioViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return audioFiles.count
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.AlbumCell, forIndexPath: indexPath) as! AlbumCell
        cell.configureForAlbumCell(albums[indexPath.row])
        return cell
    }
}

// Mark: Table View Delegate

extension MainAudioViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("AlbumDetailViewController") as! AlbumDetailViewController
        destinationVC.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

class AlbumCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artistAndAlbum: UILabel!
    
    func configureForAlbumCell(album: Album) {
        self.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        title.text = album.name
        artistAndAlbum.text = album.artist
    }
    
}
