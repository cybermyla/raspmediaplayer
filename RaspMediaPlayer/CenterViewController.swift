//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
  
  var delegate: ContainerViewControllerDelegate?
    
  // MARK: Button actions
  
  @IBAction func menuTapped(sender: AnyObject) {
    delegate?.toggleLeftPanel!()
  }
  
}