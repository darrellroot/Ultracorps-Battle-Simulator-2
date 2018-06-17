//
//  fleets.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 5/21/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import Foundation
import CoreData

var debug = false
var debugxfactor = true
var fleets = [fleet]()

var currentAttackingFleet : Int? {
    willSet(newValue) {
        if let currentAttackingFleet = currentAttackingFleet {
            fleets[currentAttackingFleet].xfactorAttacker = false
        }
    }
    didSet(oldValue) {
        if let currentAttackingFleet = currentAttackingFleet {
            fleets[currentAttackingFleet].xfactorAttacker = true
        }
    }
}
var currentDefendingFleet : Int? {
    willSet(newValue) {
        if let currentDefendingFleet = currentDefendingFleet {
            fleets[currentDefendingFleet].xfactorDefender = false
        }
    }
    didSet(oldValue) {
        if let currentDefendingFleet = currentDefendingFleet {
            fleets[currentDefendingFleet].xfactorDefender = true
        }
    }
}

var managedContext: NSManagedObjectContext!

func deleteAllCoreData() {
    if debug { print("deleteAllCoreData")}
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataFleet")
    do {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            managedContext.delete(managedObject as! NSManagedObject)
        }
    } catch let error as NSError {
        print("Delete all data error \(error) \(error.userInfo)")
    }
}

func saveData() {
    deleteAllCoreData()
    if debug { print("saveData")}
    let FleetEntity = NSEntityDescription.entity(forEntityName: "CoreDataFleet", in: managedContext)!
    let TaskForceEntity = NSEntityDescription.entity(forEntityName: "CoreDataTaskForce", in: managedContext)!
    for fleet in fleets {
        let newFleet = CoreDataFleet(entity: FleetEntity, insertInto: managedContext)
        newFleet.name = fleet.name
        for loop in 0..<units.count {
            if fleet.quantities[loop] > 0 {
                let newTaskForce = CoreDataTaskForce(entity: TaskForceEntity, insertInto: managedContext)
                newTaskForce.unitIndex = Int64(loop)
                newTaskForce.quantities = Int64(fleet.quantities[loop])
                newFleet.addToMember(newTaskForce)
            }
        }
    }
    do {
        try managedContext.save()
    } catch {
        let error = error as NSError
        print("Error saving managed context \(error) \(error.userInfo)")
    }
}

struct fleet {
    var name: String = "New Fleet"
    var quantities = [Int]()
    var survivors = [Int]()
    var xfactorAttacker = false
    var xfactorDefender = false
    
    var XAT = [Int]()
    var XDF = [Int]()
    var XOF = [Int]()
    var xfactorString = [String]()
    var XATTACKER = false
    var XDEFENDER = false
    
    var nonzeroRows: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                if quantities[count] > 0 {
                    answer += 1
                }
            }
            return answer
        }
    }
    
    func getNonZeroRow(_ row: Int) -> (String, Int, Int, String) {
        //this function returns the nth row with a non-zero quantity of units
        var nonzeroCount = 0
        for count in 0..<units.count {
            if quantities[count] > 0 {
                if nonzeroCount == row {
                    return (units[count].name, quantities[count], survivors[count], xfactorString[count])
                }
                nonzeroCount += 1
            }
        }
        return("Error", 0, 0, "")
    }
    var totalFP: Double {
        get {
            var answer = 0.0
            for count in 0..<units.count {
                answer += Double(quantities[count]) * units[count].FP
                if debug { print("count \(count) quantities \(quantities[count]) unitfp \(units[count].FP) answer \(answer)") }
            }
            return answer
        }
    }
    var survivingFP: Double {
        get {
            var answer = 0.0
            for count in 0..<units.count {
                answer += Double(survivors[count]) * units[count].FP
            }
            return answer
        }
    }
    var totalCA: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                answer += quantities[count] * units[count].CA
            }
            return answer
        }
    }
    var totalCST: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                answer += quantities[count] * units[count].price
            }
            return answer
        }
    }
    var survivingCST: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                answer += survivors[count] * units[count].price
            }
            return answer
        }
    }

    var totalCPX: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                answer += quantities[count] * units[count].CPX
            }
            return answer
        }
    }
    var survivingCPX: Int {
        get {
            var answer = 0
            for count in 0..<units.count {
                answer += survivors[count] * units[count].CPX
            }
            return answer
        }
    }

    
    init() {
        for _ in 0..<units.count {
            quantities.append(0)
            survivors.append(0)
            XAT.append(0)
            XDF.append(0)
            XOF.append(0)
            xfactorString.append("")
        }
    }
    mutating func startBattle() {
        for count in 0..<units.count {
            survivors[count] = quantities[count]
        }
    }
    mutating func calculate_xfactor(battleRound: Int) {
        if xfactorAttacker == false && xfactorDefender == false {
            print("WARNING: We are neither attacker nor defender")
        }
        if xfactorAttacker == true && xfactorDefender == true {
            print("WARNING: We are both attacker and defender")
        }
        for count in 0..<units.count {
            self.XAT[count] = units[count].AT
            self.XDF[count] = units[count].DF
            self.XOF[count] = units[count].OF
            self.xfactorString[count] = ""
            //if debugxfactor { print("\(units[count].name) count \(count) unitID units[count].unitID \(units[30].unitID) \(units[30].unitID)")}
            switch units[count].unitID {
            case 27,68: //HEW-9 and HEW-10 have bad defense if not in base fleet
                if xfactorAttacker {
                    self.XDF[count] = 1
                    self.xfactorString[count] += "DF=1"
                }
            case 30,31,32,88: // X-5Raider with space runway in same area
                if self.survivors[count] > 0 && self.survivors[1] > 0 && units[1].unitID == 26 {
                    self.XAT[count] = units[count].AT+1
                    self.XDF[count] = units[count].DF+15
                    self.xfactorString[count] += "AT+1,DF+15"
                }
            case 35:    //Thirus saucer
                if self.survivors[count] > 0 && self.survivors[30] > 0 { //If thirus saucers in same fleet
                    if units[30].unitID != 60 { //doublecheck that it is thirus saucer
                        print("XFACTOR ERROR unit30 unitID is \(units[30].unitID)")
                        self.xfactorString[count] += "XFACERR"
                    } else {
                        //Thirus saucer in same fleet as recon buggy v3
                        self.XAT[count] = 8
                        self.xfactorString[count] += "AT+4"
                    }
                }
            case 42:   //Nozama fighter
                switch self.survivors[count] {
                case 100...199:
                    if debugxfactor { print("nozama xfactor 3") }
                    self.xfactorString[count] += "AT+1"
                    self.XAT[count] = 3
                case 200...299:
                    if debugxfactor { print("nozama xfactor 4") }
                    self.xfactorString[count] += "AT+2"
                    self.XAT[count] = 4
                case 300...399:
                    if debugxfactor { print("nozama xfactor 5") }
                    self.xfactorString[count] += "AT+3"
                    self.XAT[count] = 5
                case 400...499:
                    if debugxfactor { print("nozama xfactor 6") }
                    self.xfactorString[count] += "AT+4"
                    self.XAT[count] = 6
                case 500...Int.max:
                    if debugxfactor { print("nozama xfactor 7") }
                    self.xfactorString[count] += "AT+5"
                    self.XAT[count] = 7
                default:   //nozama quantity less than 100
                    //if debugxfactor { print("no nozama xfactor") }
                    break
                }
            case 46: // Sentinel of Garasso
                if xfactorAttacker {
                    self.XDF[count] = 10
                    self.XOF[count] = 10
                    self.xfactorString[count] += "OF=10,DF=10"
                }
            case 52: // Orn moon gun
                if xfactorAttacker && battleRound < 3 {
                    self.XAT[count] = 0
                    self.xfactorString[count] += "AT=0"
                }
            default:  //no xfactors for this unit id
                break
                //if debugxfactor { print("no xfactors for \(units[count].name)") }
            }  // switch units
        }  // for count
    }
    mutating func attack(battleRound: Int) -> Int {
        calculate_xfactor(battleRound: battleRound)
        var totalHits = 0
        for count in 0..<units.count {  // type of unit attacking
            for numUnits in 0..<survivors[count] {  // number of surviving units per type
                for numAttacks in 0..<self.XAT[count] {  // number of attacks per unit
                    let n = Int(arc4random_uniform(100))
                    if n < self.XOF[count] {
                        totalHits += 1
                    }
                    if debug {
                        print("count \(count) numUnits \(numUnits) numAttacks \(numAttacks) n \(n) XOF \(self.XOF[count]) totalHits \(totalHits)")
                    }
                }
            }
        }
        return totalHits
    }
    func allDead() -> Bool {
        var totalSurvivors = 0
        for count in 0..<units.count {
            totalSurvivors = totalSurvivors + survivors[count]
        }
        return totalSurvivors == 0  // returns true if no survivors
    }
    
    mutating func impact(hits: Int) {
        var startingSurvivors = 0
        var killedSet = [Set<Int>]()
        for count in 0..<units.count {
            killedSet.append(Set<Int>())
            startingSurvivors += survivors[count]
        }
        for _ in 0..<hits {
            let hitIndex = Int(arc4random_uniform(UInt32(startingSurvivors)))
            if debug { print("raw hitindex \(hitIndex)")}
            var survivorIndex = 0
            for count in 0..<units.count {
                let previousSurvivorIndex = survivorIndex
                survivorIndex = survivorIndex + survivors[count]
                if hitIndex >= previousSurvivorIndex && hitIndex < survivorIndex {
                    let defRoll = Int(arc4random_uniform(100))
                    if debug {print("defRoll \(defRoll) XDF \(self.XDF[count])")}
                    if defRoll >= self.XDF[count] {
                        //ITS A HIT
                        killedSet[count].insert(hitIndex - previousSurvivorIndex)
                        if debug { print("killed count \(count) hitIndex \(hitIndex)")}
                    }
                }
            }
        }
        for count in 0..<units.count {
            survivors[count] = survivors[count] - killedSet[count].count
            if debug { print("count \(count) survivors \(survivors[count]) just killed \(killedSet[count].count)")}
        }
    }
}

/*struct component {
    var unit: Unit
    var quantity: Int
}*/
