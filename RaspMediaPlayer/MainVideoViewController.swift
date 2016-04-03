//
//  MainVideoViewController.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 02/04/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import UIKit

class MainVideoViewController: UIViewController {
    
    var videoFiles = [VideoFile]()
    var apiManager = ApiManager()
    @IBOutlet weak var tableView: UITableView!

    @IBAction func stopTapped(sender: AnyObject) {
        apiManager.stopVideo()
    }
    @IBAction func pauseTapped(sender: AnyObject) {
        apiManager.pauseVideo()
    }
    @IBAction func playTapped(sender: AnyObject) {
        if (tableView.indexPathForSelectedRow) != nil {
            let video = videoFiles[tableView.indexPathForSelectedRow!.row]
            apiManager.playVideo(video.fileId as! Int)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        tableView.delegate = self
        tableView.dataSource = self
        getVideoFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getVideoFiles() {
        apiManager.delegate = self
        apiManager.getVideoFiles()
    }
}

extension MainVideoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension MainVideoViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return audioFiles.count
        return videoFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.VideoCell, forIndexPath: indexPath) as! VideoCell
        cell.configureForVideoCell(videoFiles[indexPath.row])
        return cell
    }
}

extension MainVideoViewController: ApiManagerDelegate {
    func dataDownloadFinished(sender: ApiManager) {
        self.videoFiles = VideoFile.MR_findAll() as! [VideoFile]
        self.tableView.reloadData()
    }
}

class VideoCell: UITableViewCell {
    
    func configureForVideoCell(video: VideoFile) {
        self.textLabel?.text = video.title
    }
    
}
