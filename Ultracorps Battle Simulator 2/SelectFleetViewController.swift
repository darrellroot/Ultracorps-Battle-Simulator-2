//
//  SecondViewController.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit

class SelectFleetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let debug = false
    @IBOutlet weak var fleetPicker: UIPickerView!
    
    @IBAction func selectAttackButton(_ sender: UIButton) {
        if debug { print("Attack row \(fleetPicker.selectedRow(inComponent: 0))") }
        let selectedFleetNum = fleetPicker.selectedRow(inComponent: 0)
        if selectedFleetNum == currentDefendingFleet {
            let alert = UIAlertController(title: "Attacking Fleet Cannot be Same at Defending Fleet", message: "You cant fight yourself", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if selectedFleetNum < fleets.count {
            currentAttackingFleet = selectedFleetNum
        }
        updateUI()
    }
    
    @IBAction func selectDefendButton(_ sender: UIButton) {
        if debug { print("Defend row \(fleetPicker.selectedRow(inComponent: 0))") }
        let selectedFleetNum = fleetPicker.selectedRow(inComponent: 0)
        if selectedFleetNum == currentAttackingFleet {
            let alert = UIAlertController(title: "Defending Fleet Cannot be Same at Attacking Fleet", message: "You cant fight yourself", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if selectedFleetNum < fleets.count {
            currentDefendingFleet = selectedFleetNum
        }
        updateUI()
    }
    
    @IBAction func editFleetButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "EditFleet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFleet" {
            let controller = segue.destination as! EditFleetViewController
            controller.fleetToEdit = fleetPicker.selectedRow(inComponent: 0)
        }
    }
    
    @IBOutlet weak var currentAttackingFleetLabel: UILabel!
    @IBOutlet weak var currentDefendingFleetLabel: UILabel!
    
    @IBAction func deleteButton(_ sender: UIButton) {
        if debug { print("delete button pressed") }
        let deleteFleetNum = fleetPicker.selectedRow(inComponent: 0)
        if deleteFleetNum < fleets.count {
            fleets.remove(at: deleteFleetNum)
            if deleteFleetNum == currentAttackingFleet {
                currentAttackingFleet = nil
            }
            if deleteFleetNum == currentDefendingFleet {
                currentDefendingFleet = nil
            }
            if currentAttackingFleet != nil && deleteFleetNum < currentAttackingFleet! {
                currentAttackingFleet = currentAttackingFleet! - 1
            }
            if currentDefendingFleet != nil && deleteFleetNum < currentDefendingFleet! {
                currentDefendingFleet = currentDefendingFleet! - 1
            }
        }
        updateUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        if let attackFleet = currentAttackingFleet {
            currentAttackingFleetLabel.text = fleets[attackFleet].name
        } else {
            currentAttackingFleetLabel.text = "None"
        }
        if let defendFleet = currentDefendingFleet {
            currentDefendingFleetLabel.text = fleets[defendFleet].name
        } else {
            currentDefendingFleetLabel.text = "None"
        }
        fleetPicker.reloadAllComponents()

    }

    
    // MARK:- Picker View Functions
    
    func numberOfComponents(in fleetPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ fleetPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fleets.count + 1
    }
    
    func pickerView(_ fleetPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < fleets.count {
            return fleets[row].name
        } else {
            return "Add New Fleet"
        }
    }
}

