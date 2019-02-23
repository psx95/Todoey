//
//  ViewController.swift
//  Todoey
//
//  Created by Pranav Sharma on 13/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // Variables declared at the top should be initialised with a variable or they must be declared as optional.
    let realm = try! Realm()
    
    var todoItems : Results<Item>!
    
    var selectedCategory : Category? {
        didSet { // This block of code will trigger only when the Optional variable has been set.
            // This makes sure that when we do call load items, out category variable is not null.
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
//            request.predicate = predicate
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dataFilePath!)
        
    }
    
    // MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating items \(error)")
            }
        }
//        itemResults[indexPath.row].done = !itemResults[indexPath.row].done
//        //context.delete(itemArray[indexPath.row])
//        //itemArray.remove(at: indexPath.row)
//        if let nonNullResults = itemResults {
//            saveItems(item: nonNullResults[indexPath.row])
//        }
//
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in

            if self.selectedCategory != nil {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                self.saveItems(item: newItem)
                self.tableView.reloadData()
            }            
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems (item: Item) {
        do {
            try realm.write {
                selectedCategory?.items.append(item)
                realm.add(item)
            }
        } catch {
            print ("Error saving context \(error)")
        }
    }
    
    
    func loadItems () {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        print("Searc button clicked \(searchBar.text!)")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        printItemsWithDate(items: todoItems)
        tableView.reloadData()
    }
    
    func printItemsWithDate(items: Results<Item>) {
        for item in items {
            print("Item - \(item.title) created on \(item.dateCreated)")
        }
    }

    // Reverting to original list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print ("Called ")
        if searchBar.text?.count == 0 {
           // print ("Called ZERO")
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



