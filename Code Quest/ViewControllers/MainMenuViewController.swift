//
//  MainMenuViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit

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
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
		guard let presentedView = presentedViewController?.view else {
		return
		}
		if !presentedView.bounds.contains(recognizer.location(in: presentedView)) {
		self.dismiss(animated: true, completion: { () -> Void in
		})
		}
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
    
}
