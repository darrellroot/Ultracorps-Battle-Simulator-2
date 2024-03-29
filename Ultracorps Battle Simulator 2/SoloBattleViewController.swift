//
//  SoloBattleViewController.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit

class SoloBattleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var battleWasCompleted = true
    
    let debug = false

    @IBOutlet weak var fightARoundButton: UIButton!
    
    @IBOutlet weak var attackingFleetNameLabel: UILabel!
    @IBOutlet weak var defendingFleetNameLabel: UILabel!
    
    @IBOutlet weak var attackingFleetTable: UITableView!
    @IBOutlet weak var defendingFleetTable: UITableView!
    
    @IBOutlet weak var iPhoneTable: UITableView!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var attackFleetStartCST: UILabel!
    @IBOutlet weak var attackFleetStartCPX: UILabel!
    @IBOutlet weak var attackFleetStartFP: UILabel!

    @IBOutlet weak var attackFleetCurrentCST: UILabel!
    @IBOutlet weak var attackFleetCurrentCPX: UILabel!
    @IBOutlet weak var attackFleetCurrentFP: UILabel!
    
    @IBOutlet weak var defendFleetStartCST: UILabel!
    @IBOutlet weak var defendFleetStartCPX: UILabel!
    @IBOutlet weak var defendFleetStartFP: UILabel!
    
    @IBOutlet weak var defendFleetCurrentCST: UILabel!
    @IBOutlet weak var defendFleetCurrentCPX: UILabel!
    @IBOutlet weak var defendFleetCurrentFP: UILabel!
    
    
    var battleRound = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "battleTableCell", bundle: nil)
        iPhoneTable?.register(cellNib, forCellReuseIdentifier: "battleTableCell")
        updateUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentAttackingFleet == nil || currentDefendingFleet == nil {
            fightARoundButton.setTitle("", for: .normal)
            let alert = UIAlertController(title: "Go to the SELECT FLEETS screen", message: "You must select two different fleets before fighting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            fleets[currentAttackingFleet!].startBattle()
            fleets[currentDefendingFleet!].startBattle()
            battleRound = 0
            fightARoundButton?.setTitle("Start Battle!", for: .normal)
        }
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fightRoundButton(_ sender: UIButton) {
        if battleWasCompleted && currentAttackingFleet != nil && currentDefendingFleet  != nil {
            fightARoundButton.setTitle("Fight a round!", for: .normal)
            battleRound = 0
            battleWasCompleted = !battleWasCompleted
        }
        if currentAttackingFleet == nil || currentDefendingFleet == nil {
            fightARoundButton.setTitle("", for: .normal)
            let alert = UIAlertController(title: "Go to the SELECT FLEETS screen", message: "You must select two different fleets before fighting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        guard let currentAttackingFleet = currentAttackingFleet else {return}
        guard let currentDefendingFleet = currentDefendingFleet else {return}
        if battleRound == 0 {
            fleets[currentAttackingFleet].startBattle()
            fleets[currentDefendingFleet].startBattle()
            fightARoundButton.setTitle("Fight a round!", for: .normal)
        }
        let attackHits = fleets[currentAttackingFleet].attack(battleRound: battleRound)
        let defendHits = fleets[currentDefendingFleet].attack(battleRound: battleRound)
        if debug { print("attackHits \(attackHits) defendHits \(defendHits)") }
        fleets[currentAttackingFleet].impact(hits:defendHits)
        fleets[currentDefendingFleet].impact(hits:attackHits)
        battleRound += 1
        updateUI()
        if fleets[currentAttackingFleet].allDead() {
            let alert = UIAlertController(title: "Attacking Fleet Dead!", message: "They failed their people", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in self.reset() }))
            self.present(alert, animated: true)
        }
        if fleets[currentDefendingFleet].allDead() {
            let alert = UIAlertController(title: "Defending Fleet Dead!", message: "They failed their people", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in self.reset() }))
            self.present(alert, animated: true)
        }
    }
    func reset() {
        battleWasCompleted = true
        fightARoundButton.setTitle("Start Battle!", for: .normal)
        //battleRound = 0
        //fleets[currentAttackingFleet!].startBattle()
        //fleets[currentDefendingFleet!].startBattle()
        //updateUI()
    }
    func updateUI() {
        if debug { print("current attacking fleet \(String(describing: currentAttackingFleet))") }
        if debug { print("current defending fleet \(String(describing: currentDefendingFleet))") }

        if let attackingFleetNumber = currentAttackingFleet {
            attackingFleetNameLabel?.text = fleets[attackingFleetNumber].name
            attackFleetStartCST?.text = String(fleets[attackingFleetNumber].totalCST)
            attackFleetStartCPX?.text = String(fleets[attackingFleetNumber].totalCPX)
            attackFleetStartFP?.text = String(fleets[attackingFleetNumber].totalFP)
            attackFleetCurrentCST?.text = String(fleets[attackingFleetNumber].survivingCST)
            attackFleetCurrentCPX?.text = String(fleets[attackingFleetNumber].survivingCPX)
            attackFleetCurrentFP?.text = String(fleets[attackingFleetNumber].survivingFP)
        } else {
            attackingFleetNameLabel?.text = "None"
        }
        if let defendingFleetNumber = currentDefendingFleet {
            defendingFleetNameLabel?.text = fleets[defendingFleetNumber].name
            defendFleetStartCST?.text = String(fleets[defendingFleetNumber].totalCST)
            defendFleetStartCPX?.text = String(fleets[defendingFleetNumber].totalCPX)
            defendFleetStartFP?.text = String(fleets[defendingFleetNumber].totalFP)
            defendFleetCurrentCST?.text = String(fleets[defendingFleetNumber].survivingCST)
            defendFleetCurrentCPX?.text = String(fleets[defendingFleetNumber].survivingCPX)
            defendFleetCurrentFP?.text = String(fleets[defendingFleetNumber].survivingFP)
        } else {
            defendingFleetNameLabel?.text = "None"
        }
        roundLabel?.text = String(battleRound)
        attackingFleetTable?.reloadData()
        defendingFleetTable?.reloadData()
        iPhoneTable?.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {  //attacking table on ipad
            guard let currentAttackingFleet = currentAttackingFleet else {return 0}
            return fleets[currentAttackingFleet].nonzeroRows
            //return units.count
            // tag of 100 is for attacking table view
        } else if tableView.tag == 101 {  //defending table on ipad
            guard let currentDefendingFleet = currentDefendingFleet else {return 0}
            return fleets[currentDefendingFleet].nonzeroRows
            //return units.count
            // tag of 101 is for defending table view
        } else if tableView.tag == 200 { //iphone combined table
            guard let currentAttackingFleet = currentAttackingFleet else {return 0}
            guard let currentDefendingFleet = currentDefendingFleet else {return 0}
            var total = 0
            for loop in 0..<units.count {
                if fleets[currentAttackingFleet].survivors[loop] > 0 || fleets[currentDefendingFleet].survivors[loop] > 0 {
                    total = total + 1
                }
            }
            return total + 1 //adding row for FP
            //return max(fleets[currentAttackingFleet].nonzeroRows, fleets[currentDefendingFleet].nonzeroRows)
        } else {
            print("should not get here tableview tag \(tableView.tag)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisRow = indexPath.item
        if tableView.tag == 100 {
            let thisFleet = fleets[currentAttackingFleet!]
            // tag of 100 is for attacking table view
            // tag of 102 is for attacking cell label
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttackFleetCell", for: indexPath)
            let label = cell.viewWithTag(102) as! UILabel
            let (name,quantity,survivor,xfactorString) = thisFleet.getNonZeroRow(thisRow)
            label.text = "\(name) Initial \(quantity) Current \(survivor) \(xfactorString)"
            //label.text = "\(units[thisRow].name) initial \(thisFleet.quantities[thisRow]) current \(thisFleet.survivors[thisRow])"
            return cell
        } else if tableView.tag == 101 {
            let thisFleet = fleets[currentDefendingFleet!]
            // tag of 101 is for defending table view
            // tag of 103 is for defending cell label
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefendFleetCell", for: indexPath)
            let label = cell.viewWithTag(103) as! UILabel
            let (name,quantity,survivor,xfactorString) = thisFleet.getNonZeroRow(thisRow)
            label.text = "\(name) Initial \(quantity) Current \(survivor) \(xfactorString)"
            //label.text = "\(units[thisRow].name) initial \(thisFleet.quantities[thisRow]) current \(thisFleet.survivors[thisRow])"
            return cell
        } else { //iphone table tag is 200
            let attackFleet = fleets[currentAttackingFleet!]
            let defendFleet = fleets[currentDefendingFleet!]
            let cell = tableView.dequeueReusableCell(withIdentifier: "battleTableCell",for: indexPath) as! battleTableCell
            var nonzeroRow = 0
            if indexPath.row == 0 {
                cell.centerLabel.text = "FP"
                cell.leftLabel.text = "\(Int(round(attackFleet.survivingFP)))"
                cell.rightLabel.text = "\(Int(round(defendFleet.survivingFP)))"
                return cell
            }
            for loop in 0..<units.count {
                if fleets[currentAttackingFleet!].survivors[loop] > 0 || fleets[currentDefendingFleet!].survivors[loop] > 0 {
                    if nonzeroRow + 1 == indexPath.row {
                        var attxfacstring = attackFleet.xfactorString[loop]
                        var defxfacstring = defendFleet.xfactorString[loop]
                        if attackFleet.survivors[loop] == 0 {
                            attxfacstring = ""
                        }
                        if defendFleet.survivors[loop] == 0 {
                            defxfacstring = ""
                        }
                        cell.centerLabel.text = attxfacstring + " " + units[loop].name + " " + defxfacstring
                        cell.leftLabel.text = "\(attackFleet.survivors[loop])"
                        cell.rightLabel.text = "\(defendFleet.survivors[loop])"
                        return cell
                    }
                    nonzeroRow = nonzeroRow + 1
                }
            }
            cell.centerLabel.text = "error"
            cell.leftLabel.text = "0"
            cell.rightLabel.text = "0"
            return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
