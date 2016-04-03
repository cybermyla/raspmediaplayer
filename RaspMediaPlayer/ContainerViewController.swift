//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
}

@objc
protocol ContainerViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class ContainerViewController: UIViewController {
  
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    var currentState: SlideOutState = .BothCollapsed
    var leftViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        centerNavigationController.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        centerNavigationController.didMoveToParentViewController(self)
        
        //this should be changed in order to respect last selected menuitem
        menuItemSelected(MenuItem.Audio)
        toggleLeftPanel()
    }
  
}

// MARK: CenterViewController delegate
extension ContainerViewController: ContainerViewControllerDelegate, SidePanelViewControllerDelegate {

    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = self
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func collapseSidePanels() {
        let expanded = (currentState == .LeftPanelExpanded)
        if expanded {
            toggleLeftPanel()
        }
    }
    
    func menuItemSelected(item: MenuItem) {
        let vc = item.viewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: #selector(ContainerViewControllerDelegate.toggleLeftPanel))
        self.centerNavigationController.viewControllers = [vc]
        //self.collapseSidePanels()
        self.toggleLeftPanel()
    }
    
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
  
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
    
    class func mainAudioViewController() -> MainAudioViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MainAudioViewController") as? MainAudioViewController
    }
    
    class func mainRadioViewController() -> MainRadioViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MainRadioViewController") as? MainRadioViewController
    }
    
    class func mainVideoViewController() -> MainVideoViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MainVideoViewController") as? MainVideoViewController
    }
  
}