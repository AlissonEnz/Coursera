//
//  ViewController.swift
//  CoreCoursera
//
//  Created by Alisson Enz Rossi on 2/8/17.
//  Copyright © 2017 br.com.EnzRossi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var item: UITextField!
    @IBOutlet var display: UILabel!
    @IBOutlet var count: UILabel!
    
    var listMO: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        do {
            self.listMO = try managedContext.fetch(fetchRequest)
            self.reloadDisplay()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func saveAction() {
        if let txt = self.item.text, txt.characters.count > 0 {
            self.save(name: self.item.text!)
            self.item.text = ""
        }
    }

    @IBAction func deleteAction() {
        self.deleteAll()
    }
    
    func deleteAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for item in self.listMO {
            managedContext.delete(item)
        }
        
        do {
            try managedContext.save()
            self.listMO = []
            self.reloadDisplay()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
        
        let list = NSManagedObject(entity: entity, insertInto: managedContext)
        
        list.setValue(name, forKeyPath: "item")
        
        do {
            try managedContext.save()
            self.listMO.append(list)
            self.reloadDisplay()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func reloadDisplay() {
        let c = Int(self.count.text!)!
        if c < self.listMO.count {
            for i in c..<self.listMO.count {
                self.display.text?.append("\n\(self.listMO[i].value(forKeyPath: "item") as! String)")
            }
        } else {
            self.display.text = ""
        }
        self.count.text = "\(self.listMO.count)"
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
