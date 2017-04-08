//
//  MainMenuSettingsViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit

class MainMenuSettingsViewController:settingsTableViewController, UIGestureRecognizerDelegate {

    
//    var tapBGGesture: UITapGestureRecognizer!
//    override func viewDidAppear(_ animated: Bool) {
//        tapBGGesture = UITapGestureRecognizer(target: self, action: Selector("settingsBGTapped"))
//        tapBGGesture.delegate = self
//        tapBGGesture.numberOfTapsRequired = 1
//        tapBGGesture.cancelsTouchesInView = false
//        self.view.window!.addGestureRecognizer(tapBGGesture)
//    }
//    func settingsBGTapped(sender: UITapGestureRecognizer){
//        print("tapped")
//        if sender.state == UIGestureRecognizerState.ended{
//            guard let presentedView = presentedViewController?.view else {
//                return
//            }
//            if !presentedView.bounds.contains(sender.location(in: presentedView)) {
//                self.dismiss(animated: true, completion: { () -> Void in
//                })
//            }
//        }
//    }
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.view.window!.removeGestureRecognizer(tapBGGesture)
//    }

}
