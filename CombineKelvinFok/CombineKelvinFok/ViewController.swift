//
//  ViewController.swift
//  CombineKelvinFok
//
//  Created by Jihoon on 6/16/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private let vm = QuoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapRefreshButton(_ sender: UIButton) {
    }
    
}

