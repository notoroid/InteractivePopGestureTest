//
//  DetailViewController.swift
//  InteractivePopGestureTest
//
//  Created by 能登 要 on 2025/04/01.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var confirmFeatureSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue", let editiewController = segue.destination as? EditViewController {
            editiewController.enableFeature = confirmFeatureSwitch.isOn
        }


    }

}
