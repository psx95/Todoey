//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pranav Sharma on 16/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    var categoryArray: Results<Category>!
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        print(cell.textLabel?.text ?? "No Categories added yet")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print ("Add BUtton Pressed")
        
        var categoryText = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "Enter the category name", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex. Shopping List"
            categoryText = alertTextField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = categoryText.text!
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error context could not be saved \(error)")
        }
    }
    
    func load () {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let currCategory = categoryArray?[indexPath.row] {
            deleteCategory(category: currCategory)
        }
    }
    
    func deleteCategory(category: Category) {
        do {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
                }
            } catch {
                print("Error deleting category \(error)")
            }
    }
}
