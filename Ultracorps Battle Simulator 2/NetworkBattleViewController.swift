//
//  NetworkBattleViewController.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NetworkBattleViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var attackingFleetName: UILabel!
    @IBOutlet weak var defendingFleetName: UILabel!
    @IBOutlet weak var attackNetworkButton: UIButton!
    @IBOutlet weak var defendNetworkButton: UIButton!
    @IBOutlet weak var myFleetTable: UITableView!
    @IBOutlet weak var roundsFoughtLabel: UILabel!
    @IBOutlet weak var fightRoundButton: UIButton!
    @IBOutlet weak var enemyFleetTable: UITableView!
    
    let debug = true
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    let action = UIAlertAction(title: "initiate connection", style: .default, handler: nil)
    var myFleet: fleet!
    var myRound = 0
    var theirRound = 0
    var iAmAttacking = false   // true for attacking
    var iAmDefending = false   // true for defending
    var enemyUpdate: BattleUpdate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentAttackingFleet == nil || currentDefendingFleet == nil {
            let alert = UIAlertController(title: "Go to the SELECT FLEETS screen", message: "You must select two different fleets before fighting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            attackNetworkButton.isEnabled = false
            defendNetworkButton.isEnabled = false
        } else {
            attackNetworkButton.isEnabled = true
            defendNetworkButton.isEnabled = true
        }
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func attackNetworkButton(_ sender: UIButton) {
        iAmAttacking = true
        iAmDefending = false
        attackNetworkButton.isEnabled = false
        defendNetworkButton.isEnabled = false
        myFleet = fleets[currentAttackingFleet!]
        myFleet.startBattle()
        joinSession(action: action)
        updateUI()
    }
    
    @IBAction func fightRoundButton(_ sender: UIButton) {
        var hits = 0
        hits = myFleet.attack(battleRound: myRound)
        sendData(hits: hits)
        print("sent data")
    }
    @IBAction func defendNetworkButton(_ sender: UIButton) {
        iAmDefending = true
        iAmAttacking = false
        attackNetworkButton.isEnabled = false
        defendNetworkButton.isEnabled = false
        myFleet = fleets[currentDefendingFleet!]
        myFleet.startBattle()
        startHosting(action: action)
        updateUI()
    }
    
    func updateUI() {
        if mcSession.connectedPeers.count > 0 && iAmAttacking {
            fightRoundButton.isEnabled = true
        } else {
            fightRoundButton.isEnabled = false
        }
        if mcSession.connectedPeers.count == 0 {
            fightRoundButton.isEnabled = false
        }
        if let currentAttackingFleet = currentAttackingFleet {
            attackingFleetName?.text = fleets[currentAttackingFleet].name
        }
        if let currentDefendingFleet = currentDefendingFleet {
            defendingFleetName?.text = fleets[currentDefendingFleet].name
        }
        if myRound == 0 {
            fightRoundButton.setTitle("Start Battle!", for: .normal)
        } else {
            fightRoundButton.setTitle("Fight a Round!",for: .normal)
        }
        roundsFoughtLabel.text = "\(myRound)"
        myFleetTable.reloadData()
        enemyFleetTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "UltraCorps", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "UltraCorps", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    //MARK:- TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 301 {
            guard let myFleet = myFleet else { return 0 }
            print("tableview rows \(myFleet.nonzeroRows)")
            return myFleet.nonzeroRows + 3
        } else if tableView.tag == 302 {
            if let enemyUpdate = enemyUpdate {
                return enemyUpdate.fleet.nonzeroRows + 3
            } else {
                return 0
            }
        } else {
            print("ERROR should not get to end of tableview number of rows function")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 301 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFleetCell", for: indexPath)
            let label = cell.viewWithTag(300) as! UILabel
            switch indexPath.row {
            case 0:
                label.text = "My Fleet Name: \(myFleet.name)"
            case 1:
                label.text = "Starting Firepower: \(myFleet.totalFP)"
            case 2:
                label.text = "Current Firepower: \(myFleet.survivingFP)"
            default:
            let thisRow = indexPath.item - 3
            let (name,quantity,survivor,xfactorString) = myFleet.getNonZeroRow(thisRow)
            label.text = "\(name) Initial \(quantity) Current \(survivor) \(xfactorString)"
            }
            //if debug { print("label.text \(label.text)") }
            return cell
        } else if tableView.tag == 302 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFleetCell", for: indexPath)
            let label = cell.viewWithTag(300) as! UILabel
            if let enemyUpdate = enemyUpdate {
                switch indexPath.row {
                case 0:
                    label.text = "Enemy Fleet Name: \(enemyUpdate.fleet.name)"
                case 1:
                    label.text = "Starting Firepower: \(enemyUpdate.fleet.totalFP)"
                case 2:
                    label.text = "Current Firepower: \(enemyUpdate.fleet.survivingFP)"
                default:
                    let thisRow = indexPath.row - 3
                    let (name,quantity,survivor,xfactorString) = enemyUpdate.fleet.getNonZeroRow(thisRow)
                    label.text = "\(name) Initial \(quantity) Current \(survivor) \(xfactorString)"
                }
            }
            return cell
        } else {
            print("ERROR should not get to end of tableview cellforrow function")
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFleetCell", for: indexPath)
            return cell
        }
    }

    //MARK:- MULTIPEER FUNCTIONS
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
        print("Connected: \(peerID.displayName)")
        DispatchQueue.main.async { self.updateUI() }
        case MCSessionState.connecting:
        print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
        print("Not Connected: \(peerID.displayName)")
        DispatchQueue.main.async { self.updateUI() }
        }
    }
    
    func sendData(hits: Int) {
        let battleUpdate = BattleUpdate(fleet: myFleet, round: myRound, hits: hits)
        if let data = try? JSONEncoder().encode(battleUpdate) {
            print("attacking fleet encodeded")
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "SendError", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        var hits = 0
        enemyUpdate = try? JSONDecoder().decode(BattleUpdate.self, from: data)
        if let enemyUpdate = enemyUpdate {
            print("Got enemy update \(enemyUpdate.fleet.name)\n")
            if iAmDefending {
                hits = myFleet.attack(battleRound: myRound)
            }
            myFleet.impact(hits: enemyUpdate.hits)
        } else {
            print("I don't know what we got")
        }
        if iAmDefending {
            sendData(hits: hits)
        }
        myRound = myRound + 1
        DispatchQueue.main.async { self.updateUI() }
        if myFleet.allDead() {
            let alert = UIAlertController(title: "DEFEAT!", message: "We failed our people", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in self.reset() }))
            self.present(alert, animated: true)
        }
        if let enemyUpdate = enemyUpdate {
            if enemyUpdate.fleet.allDead() {
                let alert = UIAlertController(title: "VICTORY!", message: "The enemy failed their people", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in self.reset() }))
                self.present(alert, animated: true)
            }
        }
    }
    func reset() {
        myRound = 0
        fightRoundButton.setTitle("Start Battle!", for: .normal)
        myFleet.startBattle()
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    

}
