//
//  DetailsViewController.swift
//  Store
//
//  Created by Baris on 6.01.2023.
//

import Foundation
import UIKit
import SwiftUI

class DetailsViewController: UIViewController {
    //MARK: - Properties
    let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var deleteProductButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        return button
    }()
    
    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        return activityIndicatorView
    }()
  
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = product.title
        setupUI()
    }
    
    //MARK: - Functions 
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = product.description
        priceLabel.text = product.price.formatAsCurrency()
        
        // fetch the images
        Task {
            loadingIndicatorView.startAnimating()
            var images: [UIImage] = []
            for imageURL in (product.images ?? []) {
                guard let downloadedImage = await ImageLoader.load(url: imageURL) else { return }
                images.append(downloadedImage)
            }
            
            let productImageListVC = UIHostingController(rootView: ProductImageListView(images: images))
            guard let productImageListView = productImageListVC.view else { return }
            stackView.insertArrangedSubview(productImageListView, at: 0)
            addChild(productImageListVC)
            productImageListVC.didMove(toParent: self)
            loadingIndicatorView.stopAnimating()
            
        }
        
        stackView.addArrangedSubview(loadingIndicatorView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(deleteProductButton)
        
        view.addSubview(stackView)
        
        // adding constraints
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
}

