//
//  LevelTutorialViewController.swift
//  Code Quest
//
//  Created by OSX on 11/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
import AVFoundation

///Displays tutorial text
class LevelTutorialViewController: UIViewController {

    //@IBOutlet weak var tutorialLabel: UITextView!
	///The tutorial text to display
	var tutorialText : String = "Good luck!"
	///The background to display
	var background : String = "tutorial.png"
	///The parent view controller
	var myParent : LevelViewController?
	
	var layoutText : String = "layout"
	
	var speechSynthesizer = AVSpeechSynthesizer()
	var myUtterance = AVSpeechUtterance(string: "")
	
	
	//init(tutorialText : String) {
	//	self.tutorialText = tutorialText
	//	let className = NSStringFromClass((type(of: self)))
	//	super.init()//nibName : className, bundle: Bundle(for:type(of: self)))
	//
	//}
	
	//required init?(coder aDecoder: NSCoder) {
	//	fatalError("init(coder:) has not been implemented")
	//}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.preferredContentSize = CGSize(width: LevelViewController.scaleDims(input:1000, x: true), height: LevelViewController.scaleDims(input: 600, x: false))
		let backgroundImage = UIImageView(frame:CGRect(x: LevelViewController.scaleDims(input: 0, x: true), y: LevelViewController.scaleDims(input: 0, x: false), width: LevelViewController.scaleDims(input: 1000, x: true), height: LevelViewController.scaleDims(input: 600, x: false)))
		backgroundImage.image = UIImage(named: background)
		self.view.insertSubview(backgroundImage, at: 0)
		let button = UIButton(type:.system)
		button.frame = CGRect(x: LevelViewController.scaleDims(input: 750, x: true), y: LevelViewController.scaleDims(input: 450, x: false), width: LevelViewController.scaleDims(input: 200, x: true), height: LevelViewController.scaleDims(input: 100, x: false))
		button.setTitle("Start Level", for: UIControlState.normal)
		button.titleLabel!.font = button.titleLabel!.font.withSize(30)
		button.addTarget(self, action: #selector(LevelTutorialViewController.start), for: UIControlEvents.touchUpInside)
		self.view.addSubview(button)
		let label = UILabel(frame:CGRect(x: LevelViewController.scaleDims(input: 300, x: true),y: LevelViewController.scaleDims(input: 30, x: false),width: LevelViewController.scaleDims(input: 550, x: true), height: LevelViewController.scaleDims(input: 400, x: false)))
		//label.center = CGPoint(x:160, y:284)
		label.backgroundColor = .clear
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = label.font?.withSize(30)
		label.textAlignment = .center
		label.text = tutorialText
		label.textColor = UIColor.white
		self.view.addSubview(label)
		
		//let layoutButton = UIButton(type:.system)
		//layoutButton.frame = CGRect(x: LevelViewController.scaleDims(input: 50, x: true), y: LevelViewController.scaleDims(input: 50, x: false), width: LevelViewController.scaleDims(input: 200, x: true), height: LevelViewController.scaleDims(input: 100, x: false))
		//layoutButton.setTitle("LayoutButton", for: UIControlState.normal)
		
		//layoutButton.titleLabel!.font = layoutButton.titleLabel!.font.withSize(30)
		//layoutButton.addTarget(self, action: #selector(DevLevelTutorialViewController.start), for: UIControlEvents.touchUpInside)
		//layoutButton.accessibilityLabel=layoutText
		//layoutButton.isEnabled=false
		//self.view.addSubview(layoutButton)
		//layoutButton.accessibilityTraits = UIAccessibilityTraitNone
		//layoutButton.element
		//view.accessibilityElements=[layoutButton,label,button]

    }

	func start() {
		myUtterance = AVSpeechUtterance(string: layoutText)
		myUtterance.rate = 0.5 //make this a slider like volume
		myUtterance.volume = musicVolume
		if (UIAccessibilityIsVoiceOverRunning())
		{
			myUtterance.preUtteranceDelay = 6
		}
		speechSynthesizer.speak(myUtterance)
		self.dismiss(animated: true, completion: {});
		myParent?.drumPlayer.volume = 1.0 * musicVolume
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
