//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gabriel Del VIllar on 11/4/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
 let realm = try! Realm()
  var categoriesArray: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()
    }
  
  //MARK :- TableView DataSource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoriesArray?.count ?? 1
    
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No categories added yet"
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
      destinationVC.selectedCategory = categoriesArray?[indexPath.row]
    }
  }
  
  //MARK :- Data Manipulation
  func loadCategories(){
    categoriesArray = realm.objects(Category.self)
    tableView.reloadData()
  }
  
  func save(category: Category){
    do{
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context \(error)")
    }
    
    tableView.reloadData()
  }
  
  
  //MARK :- Add New Category
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category()
      newCategory.name = textField.text!
      self.save(category: newCategory)
    }
   
    
    
    alert.addTextField { (alertTextField) in
      textField = alertTextField
      alertTextField.placeholder = "Create new Category"
    }
     alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
 

}
