//
//  CategoriesTableViewController.swift
//  Store
//
//  Created by Baris on 4.01.2023.
//

import UIKit



class CategoriesTableViewController: UITableViewController {

    //MARK: - Properties
    private var client = StoreHTTPClient()
    private var categories: [Category] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Categories"


        Task {
            await populateCategories()
            tableView.reloadData()
        }
    }

    //MARK: - Functions
    
    private func populateCategories() async{
        do {
            categories =  try await client.getAllCategories()
            print(categories)
        }catch {
            // Error message
        }
    }
    
    
    
    //MARK: - Tableview properties
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let category = categories[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = category.name
        
        if let url = URL(string: category.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        configuration.image = image
                        configuration.imageProperties.maximumSize = CGSize(width: 75, height: 75)
                        cell.contentConfiguration = configuration
                    }
                }
            }
        }
        
        
       
        
        return cell
    }
    
}

