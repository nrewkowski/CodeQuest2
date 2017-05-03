//
//  MainMenuViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit
import Foundation

class MainMenuViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden=false
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
	

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.isAccessibilityElement=true
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    
//    @IBAction func settingsButtonPressed(_ sender: Any) {
//        print("attempt to hit settings")
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "mainsettings") as! MainMenuSettingsViewController
//        //vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        //vc.parentTableView = self
//        //let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        //popover = (sender as! UIButton)
//        present(vc, animated: true, completion: nil)
//    }
	
	func settingsBGTapped(recognizer: UITapGestureRecognizer){
		print("tapped")
		
		if recognizer.state == UIGestureRecognizerState.ended{
			guard let presentedView = presentedViewController?.view
			else {
                //print("strange3")
				return
			}
			if !presentedView.bounds.contains(recognizer.location(in: presentedView)) {
				self.dismiss(animated: true, completion: { () -> Void in
				
				})
			}
            else{
                self.dismiss(animated: true, completion: { () -> Void in
                    
                })
                //print("strange2")
            }
		}
        else{
            //print("strange1")
        }
	}
	
    var tapBGGesture: UITapGestureRecognizer!
    override func viewDidAppear(_ animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(self.settingsBGTapped(recognizer:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
    }
	
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        resetLevels()
        performSegue(withIdentifier: "toSolarSystem", sender: nil)
    }
    
	///Saves levels to storage
	func resetLevels () {
		//let levels =
		//let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(nil, toFile: Level.ArchiveURL.path)
		do{
			
		try FileManager.default.removeItem(atPath: Level.ArchiveURL.path)
			print("successfully deleted levels")
		}
		catch{
			print("failed deletion")
		}
//		if !isSuccessfulSave {
//			print("failed to save levels...")
//		}
//		else{
//			print("reset levels successfully")
//		}
	}
	
}
