//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

//@objc
protocol SidePanelViewControllerDelegate {
  func menuItemSelected(item: MenuItem)
}

class SidePanelViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
  
    var menuItems = ["Audio", "Video", "Settings"]
  
    
    struct TableView {
        struct CellIdentifiers {
            static let SideMenuCell = "SideMenuCell"
        }
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.reloadData()
  }
  
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SideMenuCell, forIndexPath: indexPath) as! MenuCell
    cell.configureForMenuCell(menuItems[indexPath.row])
    return cell
  }
  
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //let selectedItem = menuItems[indexPath.row]
    delegate?.menuItemSelected(MenuItem(rawValue: indexPath.row)!)
  }
  
}

class MenuCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func configureForMenuCell(menuItemName: String) {
        label.text = menuItemName
    }
    
}

enum MenuItem: Int {
    case Audio
    case Video
    case Settings
    
    func viewController() -> UIViewController {
        switch (self) {
        case Audio: return UIStoryboard.mainAudioViewController()!
        case Video: return UIStoryboard.centerViewController()!
        case Settings: return {
            let vc = UIViewController();
            vc.view.backgroundColor = UIColor.orangeColor();
            return vc
            }()
        }
    }
}