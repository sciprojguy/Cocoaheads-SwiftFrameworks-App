//
//  CachedItemsViewController.swift
//  GCache
//
//  Created by Chris Woodard on 9/13/17.
//  Copyright © 2017 UsefulSoft. All rights reserved.
//

import UIKit
import CoreLocation
import GeoCache

class CachedItemsViewController: UITableViewController, CLLocationManagerDelegate {

    var gc:GeoCache? = nil
    var items:[[String:Any]] = []
    var locationMgr:CLLocationManager = CLLocationManager()
        
    @IBOutlet var itemsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationMgr.distanceFilter = 30.0
        self.locationMgr.delegate = self
        
        self.gc = GeoCache.sharedCache(options: [:])
        self.gc?.prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadItemsAndDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadItemsAndDisplay() {
        if let items = self.gc?.cached() {
            self.items = items
            self.itemsTable.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CachedItem", for: indexPath) as! CacheItemCell
        let row = self.items[indexPath.row]
        cell.setFromDict(dict: row)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowItemDetail", sender: indexPath)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = self.items[indexPath.row]
            let result = self.gc?.delete(locationId: row["Id"] as! Int64)
            if result == CacheStatus.NoError {
                self.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else {
                //raise alert, delete failed.
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //MARK: - Location Delegate
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = segue.identifier
        if "AddItem" ==  segueId {
            let vc = segue.destination as! CachedItemDetailViewController
            vc.itemId = nil
        }
        else
        if "ShowItemDetail" ==  segueId {
            let ip = sender as! IndexPath
            let vc = segue.destination as! CachedItemDetailViewController
            let row = self.items[ip.row]
            vc.itemId = row["Id"] as? Int64
        }
    }

}
