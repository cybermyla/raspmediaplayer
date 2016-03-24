//
//  MainAudioViewController.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 23/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc
protocol MainAudioViewControllerDelegate {
    func dataLoadingFinished()
}

class MainAudioViewController: UIViewController {
    
    var audioFiles = [AudioFile]()
    
    @IBOutlet weak var tableView: UITableView!
    


    
    var delegate = self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAudioFiles()
        
        tableView.dataSource = self;
        tableView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let AudioFileCell = "AudioFileCell"
        }
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        let index = tableView.indexPathForSelectedRow!
        let audioFile = audioFiles[index.row]
        let url = "http://10.0.0.32/api/playback/play/\(audioFile.fileId)"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Play request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    @IBAction func stopTapped(sender: AnyObject) {
        let url = "http://10.0.0.32/api/playback/stop"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Stop request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    @IBAction func pauseTapped(sender: AnyObject) {
        let url = "http://10.0.0.32/api/playback/pause"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Pause request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getAudioFiles() {
        let url = "http://10.0.0.32/api/media/getallaudiofiles"
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subjsn):(String, JSON) in json {
                        
                        let fileId = subjsn["id"].intValue
                        let title = subjsn["title"].stringValue
                        var artist = ""
                        if let art = subjsn["artist"].string {
                            artist = art
                        }
                        var track = ""
                        if let trc = subjsn["track"].string {
                            track = trc
                        }
                        let album = subjsn["album"].stringValue
                        
                        self.audioFiles.append(AudioFile(fileId: fileId, title: title, artist: artist, track: track, album: album))
                    }
                    self.dataLoadingFinished()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }


}


// MARK: Table View Data Source

extension MainAudioViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.AudioFileCell, forIndexPath: indexPath) as! AudioFileCell
        cell.configureForAudioFileCell(audioFiles[indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension MainAudioViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //delegate?.menuItemSelected(MenuItem(rawValue: indexPath.row)!)
    }
    
}

extension MainAudioViewController: MainAudioViewControllerDelegate {
    func dataLoadingFinished() {
        self.tableView.reloadData();
    }
}

class AudioFileCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artistAndAlbum: UILabel!
    
    func configureForAudioFileCell(audioFile: AudioFile) {
        title.text = audioFile.title
        artistAndAlbum.text = audioFile.album
    }
    
}
