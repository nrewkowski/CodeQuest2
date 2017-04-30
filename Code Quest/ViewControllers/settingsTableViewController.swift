//
//  settingsTableViewController.swift
//  Code Quest
//
//  Created by OSX on 12/12/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class settingsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	var parentTableView : LevelTableViewController?
	var defaults = UserDefaults.standard
	
    @IBOutlet weak var musicUISlider: UISlider!
    @IBAction func musicSliderChanged(_ sender: Any) {
        print(musicUISlider.value)
        musicVolume = musicUISlider.value
        defaults.set(musicVolume, forKey: "musicVolume")
    }

    
    @IBAction func AddCustomLevel(_ sender: Any) {
		if (parentTableView != nil){
			parentTableView!.newMaze();
		}
		else{
			print("no parent")
		}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.preferredContentSize = CGSize(width: 500, height: 150)
		musicUISlider.setValue(musicVolume, animated: false)
		
			// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath == IndexPath(item: 1, section: 0)) {
            parentTableView?.newMaze()
        } else if (indexPath == IndexPath(item: 2, section: 0)) {
			self.dismiss(animated: true, completion: {})
        }
    }*/
	
	
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
