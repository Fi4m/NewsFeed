//
//  SideMenuTVC.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 27/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit

enum SideMenuType {
    case categorySelection
    case sourcesSelection
}

class SideMenuTVC: UITableViewController {
    
    var sideMenuType: SideMenuType = .categorySelection
    var selectedCategory: String!
    
    var categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var sources: [[String:Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if sideMenuType == .sourcesSelection {
            callSources(category: self.selectedCategory)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if sideMenuType == .categorySelection {
            return categories.count
        } else {
            return sources.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)

        if sideMenuType == .categorySelection {
            cell.textLabel?.text = categories[indexPath.row]
        } else {
            cell.textLabel?.text = sources[indexPath.row]["name"] as? String
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sideMenuType == .categorySelection {
//            sideMenuType = .sourcesSelection
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTVC") as! SideMenuTVC
            destination.sideMenuType = .sourcesSelection
            destination.selectedCategory = self.categories[indexPath.row]
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
            self.revealViewController().revealToggle(self)
            NotificationCenter.default.post(name: NSNotification.Name("SourceSelected"), object: nil, userInfo: ["source": sources[indexPath.row]["id"] as! String])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func callSources(category: String) {
        WebService.shared.callAPI(.get, api: .sources, parameters: ["country": "us", "category": category]) { (response) in
            unowned let this = self
            this.sources = response["sources"] as! [[String : Any]]
        }
    }
 

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
