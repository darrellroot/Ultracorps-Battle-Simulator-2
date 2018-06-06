//
//  EditFleetViewController.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit

class EditFleetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return units.count
        if let fleetToEdit = fleetToEdit {
            return fleets[fleetToEdit].nonzeroRows
        }
        return 0
    }
    var fleetToEdit: Int?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentFP: UILabel!
    @IBOutlet weak var currentCST: UILabel!
    @IBOutlet weak var currentCPX: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditFleetCell", for: indexPath)
        let label = cell.viewWithTag(300) as! UILabel
        label.text = "unable to fill"
        if let fleetToEdit = fleetToEdit {
            let (unitName, unitQty, _) = fleets[fleetToEdit].getNonZeroRow(indexPath.item)
            label.text = unitName + " " + String(unitQty)
            //label.text = units[indexPath.item].name + String(describing:fleets[fleetToEdit].quantities[indexPath.item])
         }
        return cell
    }
    

    
    @IBOutlet weak var fleetNameField: UITextField!
    
    @IBOutlet weak var newQuantityField: UITextField!
    /*@IBAction func setNewQuantity(_ sender: UIButton) {
        if let newQuantity = Int(newQuantityField.text!) {
            if let fleetNumber = fleetToEdit {
                fleets[fleetNumber].quantities[unitPicker.selectedRow(inComponent: 0)] = newQuantity
            }
        }
        tableView.reloadData()
     }*/
    @IBOutlet weak var unitPicker: UIPickerView!
    
    /*@IBAction func setFleetName(_ sender: UIButton) {
        if let fleetNumber = fleetToEdit {
            if let newName = fleetNameField.text {
                fleets[fleetNumber].name = newName
            }
        }
    }*/
    @IBAction func doneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fleetNumber = fleetToEdit {
            if fleetNumber == fleets.count {
                // create new fleet
                let newFleet = fleet()
                fleets.append(newFleet)
            }
        }
        fleetNameField.delegate = self
        newQuantityField.delegate = self
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 800 {
            if let fleetNumber = fleetToEdit {
                if let newName = fleetNameField.text {
                    fleets[fleetNumber].name = newName
                }
            }
        }
        if textField.tag == 801 {
            if let newQuantity = Int(newQuantityField.text!) {
                if let fleetNumber = fleetToEdit {
                    fleets[fleetNumber].quantities[unitPicker.selectedRow(inComponent: 0)] = newQuantity
                }
            }
            updateUI()
        }
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        if let fleetNumber = fleetToEdit {
            fleetNameField.text = fleets[fleetNumber].name
            currentFP.text = String(fleets[fleetNumber].totalFP)
            currentCST.text = String(fleets[fleetNumber].totalCST)
            currentCPX.text = String(fleets[fleetNumber].totalCPX)
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK:- Picker View Functions
    
    func numberOfComponents(in unitPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ unitPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ unitPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row].name
    }


}
