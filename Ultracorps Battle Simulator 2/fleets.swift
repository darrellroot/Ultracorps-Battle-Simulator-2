//
//  fleets.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 5/21/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import Foundation

var debug = false
var debugxfactor = true
var fleets = [fleet]()

var currentAttackingFleet : Int?
var currentDefendingFleet : Int?

struct fleet {
    var name: String = "New Fleet"
    var quantities = [Int]()
    var survivors = [Int]()
    
    var XAT = [Int]()
    
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
    
    func getNonZeroRow(_ row: Int) -> (String, Int, Int) {
        //this function returns the nth row with a non-zero quantity of units
        var nonzeroCount = 0
        for count in 0..<units.count {
            if quantities[count] > 0 {
                if nonzeroCount == row {
                    return (units[count].name, quantities[count], survivors[count])
                }
                nonzeroCount += 1
            }
        }
        return("Error", 0, 0)
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
        }
    }
    mutating func startBattle() {
        for count in 0..<units.count {
            survivors[count] = quantities[count]
        }
    }
    mutating func calculate_xfactor() {
        for count in 0..<units.count {
            self.XAT[count] = units[count].AT
            switch units[count].unitID {
            case 42:   //Nozama fighter
                switch self.survivors[count] {
                case 100...199:
                    if debugxfactor { print("nozama xfactor 3") }
                    self.XAT[count] = 3
                case 200...299:
                    if debugxfactor { print("nozama xfactor 4") }
                    self.XAT[count] = 4
                case 300...399:
                    if debugxfactor { print("nozama xfactor 5") }
                    self.XAT[count] = 5
                case 400...499:
                    if debugxfactor { print("nozama xfactor 6") }
                    self.XAT[count] = 6
                case 500...Int.max:
                    if debugxfactor { print("nozama xfactor 7") }
                    self.XAT[count] = 7
                default:   //nozama quantity less than 100
                    if debugxfactor { print("no nozama xfactor") }
                }
            default:  //no xfactors for this unit id
                if debugxfactor { print("no xfactors for \(units[count].name)") }
            }  // switch units
        }  // for count
    }
    mutating func attack() -> Int {
        calculate_xfactor()
        var totalHits = 0
        for count in 0..<units.count {  // type of unit attacking
            for numUnits in 0..<survivors[count] {  // number of surviving units per type
                for numAttacks in 0..<self.XAT[count] {  // number of attacks per unit
                    let n = Int(arc4random_uniform(100))
                    if n < units[count].OF {
                        totalHits += 1
                    }
                    if debug {
                        print("count \(count) numUnits \(numUnits) numAttacks \(numAttacks) n \(n) OF \(units[count].OF) totalHits \(totalHits)")
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
                    if debug {print("defRoll \(defRoll) DF \(units[count].DF)")}
                    if defRoll >= units[count].DF {
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
