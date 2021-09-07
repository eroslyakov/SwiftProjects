//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rosliakov Evgenii on 04.08.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var realm: Realm!
    var categories: Results<TodoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = (UIApplication.shared.delegate as! AppDelegate).realm!
        fetchAllFromRealm()
    }
    
    //MARK: - TableView Datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SwipeTableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            if category.color == nil {
                do {
                    try realm.write({
                        category.color = RandomFlatColorWithShade(.light).hexValue()
                    })
                } catch {
                    print("Error updating category cell color property: \(error)")
                }
            }
            
            cell.textLabel?.text = category.name
            if let hexColor = category.color, let color = UIColor(hexString: hexColor) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Categories added"
        }
        
        return cell
    }
    
    
    //MARK: - Data manipulation methods
    
    func fetchAllFromRealm() {
        categories = realm.objects(TodoCategory.self)
    }
    
    func create(category: TodoCategory) {
        do {
            try realm.write({
                realm.add(category)
            })
            tableView.reloadData()
        } catch {
            print("Error saving category to Realm: \(error)")
        }
    }
    
    func delete(category: TodoCategory) {
        do {
            try realm.write({
                realm.delete(category)
            })
        } catch {
            print("Error deleting category from Realm: \(error)")
        }
    }
    
    override func updateModal(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            delete(category: category)
        }
    }
    
    
    //MARK: - Add new Categories
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            textField = alertTextField
            textField.placeholder = "Print a new category name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default) { action in
            guard let textInput = textField.text, textInput.trimmingCharacters(in: [" "]).count != 0 else {
                return
            }
            let newCategory = TodoCategory()
            newCategory.name = textInput
            newCategory.color = RandomFlatColor().hexValue()
            self.create(category: newCategory)
        })
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems", let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
}

