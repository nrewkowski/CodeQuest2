//
//  MainMenuSettingsViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit
import SSAccessibility

class MainMenuSettingsViewController:settingsTableViewController, UIGestureRecognizerDelegate {

	var synthesizer : SSSpeechSynthesizer? = nil
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
	override func viewDidLoad() {
		super.viewDidLoad()
		synthesizer = SSSpeechSynthesizer()
        addCustomLevelButton.isEnabled = false
        //addCustomLevelButton.isAccessibilityElement = false
        //addCustomLevelButton.isHidden = true
		
		//synthesizer
	}
    override func viewDidAppear(_ animated: Bool) {
        
        //self.accessibilityLabel = "test"
        //self.accessibilityElements = [musicUISlider]
		//synthesizer?.enqueueLine(forSpeaking: "test")
        //self.title = "BABABABAB"
		
        //self.tableView.viewfor
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Settings"
    }
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var overallView = UIView(frame: CGRect(x:0, y:0, width:320, height:44))
        var lbl_header = UILabel()
        lbl_header.frame = CGRect(x:10, y:5, width:320, height:30)
        lbl_header.text = "Settings"
        lbl_header.backgroundColor = UIColor.clear
        lbl_header.accessibilityLabel = "Settings. Double tap to dismiss."
        overallView.addSubview(lbl_header)
        return overallView;
	}
    @IBOutlet weak var addCustomLevelButton: UIButton!
}
