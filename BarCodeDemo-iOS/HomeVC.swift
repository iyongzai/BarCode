//
//  HomeVC.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/30.
//

import UIKit

enum Jump: String {
    enum UPC: String {
        case upca = "UPC-A"
        case upce = "UPC-E"
    }
    case gotoUPCVC
}

class HomeVC: UITableViewController {
    
    var data = [("UPC", [Jump.UPC.upca.rawValue, Jump.UPC.upce.rawValue])]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section].1[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let itemTitle = data[indexPath.section].1[indexPath.row]
        switch itemTitle {
        case Jump.UPC.upca.rawValue:
            self.performSegue(withIdentifier: Jump.gotoUPCVC.rawValue, sender: itemTitle)
        case Jump.UPC.upce.rawValue:
            self.performSegue(withIdentifier: Jump.gotoUPCVC.rawValue, sender: itemTitle)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let jumpID = Jump(rawValue: segue.identifier ?? "") else { return }

        switch jumpID {
        case .gotoUPCVC:
            guard let itemTitle = sender as? String else { return }
            switch itemTitle {
            case Jump.UPC.upca.rawValue:
                (segue.destination as? UPCVC)?.barCode = .upca("042100005264")
            case Jump.UPC.upce.rawValue:
                (segue.destination as? UPCVC)?.barCode = .upce("00123457")
            default:
                break
            }
        }
    }
}
