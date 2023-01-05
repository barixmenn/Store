//
//  ProductTableViewController.swift
//  Store
//
//  Created by Baris on 4.01.2023.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    //MARK: - Properties
    private var category : Category
    private var products : [Product] = []
    private var client = StoreHTTPClient()
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Lifecycle     
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        navigationController?.navigationBar.prefersLargeTitles = true
        title = category.name
        
        Task {
            await getPopularProducts()
        }
    }
    
    //MARK: - Functions
    private func getPopularProducts () async {
        do {
            products = try await client.getProductsByCategory(categoryId: category.id)
            tableView.reloadData()
            print(products)
            
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - Table view sources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)     
        let product = products[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = product.title
        configuration.secondaryText = product.description
        cell.contentConfiguration = configuration
        return cell
    }
}
