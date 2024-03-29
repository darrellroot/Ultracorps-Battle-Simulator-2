//
//  EditFleetViewController.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit

class EditFleetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0
    
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
    let device = UIDevice.current.userInterfaceIdiom
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditFleetCell", for: indexPath)
        let label = cell.viewWithTag(300) as! UILabel
        label.text = "unable to fill"
        if let fleetToEdit = fleetToEdit {
            let (unitName, unitQty, _, _) = fleets[fleetToEdit].getNonZeroRow(indexPath.item)
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
        saveData()
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if device != .pad { tableView.rowHeight = 24 }
        if let fleetNumber = fleetToEdit {
            if fleetNumber == fleets.count {
                // create new fleet
                let newFleet = fleet()
                fleets.append(newFleet)
            }
        }
        fleetNameField.delegate = self
        newQuantityField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if keyboardAdjusted == false && newQuantityField.isFirstResponder {
            lastKeyboardOffset = getKeyboardHeight(notification: notification)
            view.frame.origin.y -= lastKeyboardOffset
                keyboardAdjusted = true
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if keyboardAdjusted == true {
            view.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func hideKeyboard() {
        for textField in self.view.subviews where textField is UITextField {
            if textField.isFirstResponder {
                _ = textFieldShouldReturn(textField as! UITextField)
            }
        }
        //view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textfieldshould return")
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
            currentCST?.text = String(fleets[fleetNumber].totalCST)
            currentCPX?.text = String(fleets[fleetNumber].totalCPX)
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
