//
//  DevLevelTutorialViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 3/28/17.
//  Copyright © 2017 Spookle. All rights reserved.
//


import UIKit

///Displays tutorial text
class DevLevelTutorialViewController: UIViewController {
	
	//@IBOutlet weak var tutorialLabel: UITextView!
	///The tutorial text to display
	var tutorialText : String = "Good luck!"
	///The background to display
	var background : String = "tutorial.png"
	///The parent view controller
	var myParent : PlanetLevelViewController?
	
	
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
		
	}
	
	func start() {
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
