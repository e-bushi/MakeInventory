//
//  AddInventoryViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit

class AddInventoryViewController: UIViewController {
    let coreDataStack = CoreDataStack.instance
    
    var inventory: Inventory?
    
    @IBOutlet weak var inventoryNameField: UITextField!
    @IBOutlet weak var inventoryQuantityField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inventory = inventory {
            inventoryNameField.text = inventory.name
            inventoryQuantityField.text = String(describing: inventory.quantity)
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard let name = inventoryNameField.text, let quantity = Int64(inventoryQuantityField.text!) else {return}
        
            //if inventory value isn't nil, we'll assign it the inventory variable -
        if let inventory = inventory {
            //we access the specific inventory object
            let bgEntity = coreDataStack.privateContext.object(with: inventory.objectID) as! Inventory
            
            //use
            bgEntity.name = name
            bgEntity.quantity = quantity
            bgEntity.date = Date()
            
            coreDataStack.saveTo(context: coreDataStack.privateContext)
            self.coreDataStack.viewContext.refresh(inventory, mergeChanges: true)
        } else {
        
        
            let inv = Inventory(context: coreDataStack.privateContext)
            
            
            inv.name = name
            inv.quantity = quantity
            inv.date = Date()
            
            
            coreDataStack.saveTo(context: coreDataStack.privateContext)
            
        }
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    
}
