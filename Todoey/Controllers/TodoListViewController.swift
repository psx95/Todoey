//
//  ViewController.swift
//  Todoey
//
//  Created by Pranav Sharma on 13/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    // Variables declared at the top should be initialised with a variable or they must be declared as optional.
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>!
    var categoryColor: String = ""
    
    var selectedCategory : Category? {
        didSet { // This block of code will trigger only when the Optional variable has been
            categoryColor = (selectedCategory?.color)!
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dataFilePath!)            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else { fatalError() }
        updateNavBar(withHexColor: colorHex)
        title = selectedCategory!.name
    }
    
    // MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt:  indexPath)
       
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: categoryColor)?.darken(byPercentage: ((CGFloat)(indexPath.row)/(CGFloat)(todoItems!.count)))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
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
    
    //MARK : DATA Model related functions
    
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
    
    func deleteItem(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print ("Error deleting item \(error)")
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = todoItems?[indexPath.row] {            
            deleteItem(item: itemToDelete)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexColor: "1D9BF6")
    }
    
    func updateNavBar(withHexColor hexColor: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("NavigationController does not exist") }
        
        guard let navBarColor = UIColor(hexString: hexColor) else {
            fatalError()
        }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        print("Searc button clicked \(searchBar.text!)")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
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



