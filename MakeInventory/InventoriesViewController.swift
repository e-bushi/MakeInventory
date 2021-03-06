//
//  ViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class InventoriesViewController: UIViewController {
    let stack = CoreDataStack.instance
    
    @IBOutlet weak var tableView: UITableView!
    var inventories = [Inventory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetch = NSFetchRequest<Inventory>(entityName: "Inventory")
        do {
            let result = try stack.viewContext.fetch(fetch)
            self.inventories = result
            self.tableView.reloadData()
            
        }catch let error {
            print(error)
        }
    }
    
    
}


extension InventoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories.count
    }
}

extension InventoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryTableViewCell
        
        
        
        
        let item = inventories[indexPath.row]
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: item.date!)
        let minute = calendar.component(.minute, from: item.date!)
        let second = calendar.component(.second, from: item.date!)
        
        cell.titleLabel.text = item.name
        cell.quantityLabel.text = "x\(item.quantity)"
        cell.dateLabel.text = "\(hour):\(minute):\(second)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get index
        let row = indexPath.row
        let item = inventories[row]
        let addInventoryVC = storyboard?.instantiateViewController(withIdentifier: "AddInventoryViewController") as! AddInventoryViewController
        addInventoryVC.inventory = item
        
        
        
        self.navigationController?.pushViewController(addInventoryVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let id = stack.privateContext.object(with: inventories[row].objectID)
        
        if editingStyle == .delete {
//            stack.viewContext.delete(id)
            stack.privateContext.delete(id)
            
            inventories.remove(at: row)
            
            stack.saveTo(context: stack.privateContext)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
