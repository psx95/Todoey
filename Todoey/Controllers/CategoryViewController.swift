//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pranav Sharma on 16/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray: [Category] = []
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryShopping = Category(context: context)
        categoryShopping.name = "Shopping"
        categoryShopping.count = 0
        
        
        categoryArray.append(categoryShopping)
        
        let categoryChecklist = Category(context: context)
        categoryChecklist.name = "Checklist"
        categoryShopping.count = 0
        
        categoryArray.append(categoryChecklist)
        
        save()
        load()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print ("Add BUtton Pressed")
    }
    
    func save () {
        do {
            try context.save()
        } catch {
            print("Error context could not be saved \(error)")
        }
    }
    
    func load (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error loading context \(error)")
        }
    }
}
