//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gabriel Del VIllar on 11/4/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  var categoriesArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  

    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()
    }
  
  //MARK :- TableView DataSource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoriesArray.count
    
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoriesArray[indexPath.row].name!
    print(categoriesArray[indexPath.row].name!)
    print(cell.textLabel!)
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
      destinationVC.selectedCategory = categoriesArray[indexPath.row]
    }
  }
  
  //MARK :- Data Manipulation
  func loadCategories(){
    
    let request : NSFetchRequest<Category> = Category.fetchRequest()
    
    do {
      categoriesArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
  
    tableView.reloadData()
   
  }
  
  func saveCategories(){
    do{
      try context.save()
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
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      self.categoriesArray.append(newCategory)
      
      self.saveCategories()
      print(self.categoriesArray.count)
    }
   
    
    
    alert.addTextField { (alertTextField) in
      textField = alertTextField
      alertTextField.placeholder = "Create new Category"
    }
     alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
 

}
