//
//  MainRadioViewController.swift
//  RaspMediaPlayer
//
//  Created by Miloslav Linhart on 28/03/16.
//  Copyright © 2016 Miloslav Linhart. All rights reserved.
//

import UIKit

class MainRadioViewController: UIViewController {

    var radioStations = [RadioStation]()
    
    var apiManager = ApiManager();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Radio Stations"
        
        getRadioStations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        let radioStation = radioStations[tableView.indexPathForSelectedRow!.row]
        apiManager.playRadio(radioStation.radioId as! Int)
    }

    @IBAction func stopTapped(sender: AnyObject) {
        apiManager.stopRadio()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getRadioStations() {
        apiManager.delegate = self
        apiManager.getRadioStations()
    }
    

}

// MARK: Table View Data Source

extension MainRadioViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.radioStations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.RadioCell, forIndexPath: indexPath) as! RadioCell
        cell.configureForRadioCell(self.radioStations[indexPath.row])
        return cell
    }
}

// Mark: Table View Delegate

extension MainRadioViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //delegate?.menuItemSelected(MenuItem(rawValue: indexPath.row)!)
    }
}

extension MainRadioViewController: ApiManagerDelegate {
    func dataDownloadFinished(sender: ApiManager) {
        self.radioStations = RadioStation.MR_findAll() as! [RadioStation]
        self.tableView.reloadData()
    }
}

class RadioCell: UITableViewCell {
    
    @IBOutlet weak var stationName: UILabel!
    
    func configureForRadioCell(radioFile: RadioStation) {
        stationName.text = radioFile.name
    }
}
