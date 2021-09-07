//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = (UIApplication.shared.delegate as! AppDelegate).realm!
    
    var todoItems: Results<TodoItem>?
    var selectedCategory: TodoCategory? {
        didSet {
            fetchItemsForCategory()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.title = selectedCategory?.name ?? "To Do Items"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            guard  let navBar = navigationController?.navigationBar, let color = UIColor(hexString: colorHex) else {
                fatalError("Navigation Bar does not exist")
            }
            let contrastColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            navBar.barTintColor = color
            navBar.backgroundColor = color
            navBar.tintColor = contrastColor
            navBar.largeTitleTextAttributes = [.foregroundColor: contrastColor]
            searchBar.backgroundImage = UIImage()
            searchBar.backgroundColor = color
            searchBar.barTintColor = color
            searchBar.tintColor = color
            searchBar.searchTextField.backgroundColor = .white
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .systemTeal
        navigationController?.navigationBar.backgroundColor = .systemTeal
    }
    
    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SwipeTableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel!.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
                cell!.accessoryType = item.done ? .checkmark : .none
            } catch {
                print("Error updating Realm entity: \(error)")
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ----------------------------------

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Add item", style: .default) { _ in
            if let inputText = textField?.text,
               inputText.trimmingCharacters(in: [" "]) != "" {
                
                do {
                    if let currentCategory = self.selectedCategory {
                        try self.realm.write{
                            let newItem = TodoItem()
                            newItem.title = inputText
                            currentCategory.items.append(newItem)
                        }
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving into Realm: \(error)")
                }
            }
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func fetchItemsForCategory() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModal(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print("Error deleting ToDo item: \(error)")
            }
        }
    }
    
}

//MARK: - SearchBar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchItemsForCategory()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

