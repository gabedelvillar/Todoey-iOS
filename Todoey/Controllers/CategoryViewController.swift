//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gabriel Del VIllar on 11/4/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
 let realm = try! Realm()
  var categoriesArray: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()
      tableView.separatorStyle = .none
      
      
    }
  
  //MARK :- TableView DataSource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoriesArray?.count ?? 1
    
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    
    if let category = categoriesArray?[indexPath.row]{
      cell.textLabel?.text = category.name
      
      guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
      
      cell.backgroundColor = categoryColor
      cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
    }
    
   
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
  
  //MARK: - Delete Data From Swipe
  override func updateModel(at indexPath: IndexPath){
    if let categoryForDeleteion = self.categoriesArray?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(categoryForDeleteion)
        }
      } catch {
        print("Error deleting, \(error)")
      }
    }
  }
  
  //MARK :- Add New Category
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category()
      newCategory.name = textField.text!
      newCategory.color = UIColor.randomFlat.hexValue()
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


