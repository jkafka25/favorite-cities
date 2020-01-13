//
//  DetailViewController.swift
//  favorite cities
//
//  Created by Jack Kafka on 1/10/20.
//  Copyright © 2020 Jack Kafka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var populationTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    var detailItem: City? {
        didSet {
            // Update the view.
            configureView()
        }
        
    }
    func configureView() {
        // Update the user interface for the detail item
        if let city = self.detailItem {
            if cityTextField != nil {
                cityTextField.text = city.name
                stateTextField.text = city.state
                populationTextField.text = String(city.population)
                imageView.image = UIImage(data: city.image)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = self.detailItem {
           city.name = cityTextField.text!
           city.state = stateTextField.text!
           city.population = Int(populationTextField.text!)!
        }
    }

    
    
}

