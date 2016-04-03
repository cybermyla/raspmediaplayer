//
//  PlaybackManager.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 26/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MagicalRecord

protocol ApiManagerDelegate {
    func dataDownloadFinished(sender: ApiManager)
}

class ApiManager {
    
    //static let sharedInstance = AudioApiManager()
    var delegate: ApiManagerDelegate?
    let address = "10.0.0.32"
    
    func playSong(songId: Int) {
        let url = "http://\(address)/api/playback/play/\(songId)"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Play request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func stopSong() {
        let url = "http://\(address)/api/playback/stop"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Stop request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func pauseSong() {
        let url = "http://\(address)/api/playback/pause"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Pause request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getAudioFiles() {
        let url = "http://\(address)/api/media/getallaudiofiles"
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                AudioFile.MR_truncateAll()
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
                        
                        let audioFile = AudioFile.MR_createEntity()
                        audioFile?.fileId = fileId
                        audioFile?.title = title
                        audioFile?.artist = artist
                        audioFile?.track = track
                        audioFile?.album = album
                        
                    }
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()

                    self.delegate?.dataDownloadFinished(self)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    func getRadioStations() {
        let url = "http://\(address)/api/media/getradiostations"
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                RadioStation.MR_truncateAll()
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subjsn):(String, JSON) in json {
                        
                        let id = subjsn["id"].intValue
                        let name = subjsn["name"].stringValue
                        let address = subjsn["address"].stringValue
                        
                        let radioStation = RadioStation.MR_createEntity()
                        radioStation?.radioId = id
                        radioStation?.name = name
                        radioStation?.address = address
                        
                    }
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    
                    self.delegate?.dataDownloadFinished(self)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func stopRadio() {
        let url = "http://\(address)/api/radio/stop"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Stop request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func playRadio(radioId: Int) {
        let url = "http://\(address)/api/radio/play/\(radioId)"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Play request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getVideoFiles() {
        let url = "http://\(address)/api/media/getallvideofiles"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                VideoFile.MR_truncateAll()
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subjsn):(String, JSON) in json {
                        
                        let id = subjsn["id"].intValue
                        let title = subjsn["title"].stringValue
                        
                        let videoFile = VideoFile.MR_createEntity()
                        videoFile?.fileId = id
                        videoFile?.title = title
                        
                    }
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    
                    self.delegate?.dataDownloadFinished(self)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func playVideo(fileId: Int) {
        let url = "http://\(address)/api/video/play/\(fileId)"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Play request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func stopVideo() {
        let url = "http://\(address)/api/video/stop"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Stop request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func pauseVideo() {
        let url = "http://\(address)/api/video/pause"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Pause request successfully sent")
            case .Failure(let error):
                print(error)
            }
        }
    }
}
