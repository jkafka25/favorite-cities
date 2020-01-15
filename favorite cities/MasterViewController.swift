//
//  MasterViewController.swift
//  favorite cities
//
//  Created by Jack Kafka on 1/10/20.
//  Copyright © 2020 Jack Kafka. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var cities = [City]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        saveData()
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "City"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "State"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Population"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let insertAction = UIAlertAction(title: "Add", style: .default) { (action) in let cityTextField = alert.textFields![0] as UITextField
            let stateTextField = alert.textFields![1] as UITextField
            let populationTextField = alert.textFields![2] as UITextField
            guard let image = UIImage(named: cityTextField.text!) else{
                print("missing \(cityTextField.text!) image")
                return }
            if let population = Int(populationTextField.text!) {
                let city = City(name: cityTextField.text!,
                                state: stateTextField.text!,
                                population: population,
                                image: image.pngData()!)
                self.cities.append(city)
                self.tableView.reloadData()
                self.saveData()
            }
            
        }
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
        
    }
    func saveData() {
        if let encoded = try? JSONEncoder().encode(cities) {
            defaults.set(encoded, forKey: "data")
        }
    }
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = cities[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = cities[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
        }
    }
    
    
}

