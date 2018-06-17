//
//  units.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 5/21/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import Foundation

protocol Unit {
    var OF: Int {get}
    var DF: Int {get}
    var AT: Int {get}
    var CA: Int {get}
    var price: Int {get}
    var CPX: Int {get}
    var unitID: Int {get}
    var name: String {get}
    var FP: Double {get}
}

let units: [Unit] = [Crawler() as Unit, Runway() as Unit, Eliminator() as Unit, Megabot() as Unit, Incinerator() as Unit, Raider() as Unit, Instigator() as Unit, Corvette() as Unit, Boron() as Unit, Hurax() as Unit, Thirus() as Unit, Fighter() as Unit, Giganto() as Unit, Rover() as Unit, Wrecker() as Unit, Battleship() as Unit, Nozama() as Unit, TkBike() as Unit, CrOrg() as Unit, Infinita() as Unit, Sentinel() as Unit, XironMediumCruiser() as Unit, Scout() as Unit, Mauler() as Unit, CrOrgII() as Unit, TkTank() as Unit, OrnMoonGun() as Unit, Suicide() as Unit, TkPsiHauler() as Unit, BoronV2() as Unit, BoronV3() as Unit, CROrgIIv2() as Unit, CROrgIIv3() as Unit, CROrgIIv4() as Unit, Annihilator() as Unit, BattleshipV2() as Unit, BattleStation() as Unit, TkBikeV2() as Unit, ZenrinMonk() as Unit, ZenrinFighter() as Unit, ZenrinWarrior() as Unit, ZenrinMaster() as Unit, MegaBotV2() as Unit, MegaBotV3() as Unit, MegaBotV4() as Unit, Shuttle() as Unit, WarMek() as Unit, NozamaQueen() as Unit, XironHeavyCruiserV2() as Unit, Scuttler() as Unit ]

//0
struct Crawler: Unit {
    let OF = 25
    let DF = 90
    let AT = 2
    let CA = 200
    let price = 50
    let CPX = 150
    let unitID = 25
    let name = "ATO-3 Crawler"
    let FP = 2.24
}

//1
struct Runway: Unit {
    let OF = 40
    let DF = 98
    let AT = 25
    let CA = 500
    let price = 200
    let CPX = 1200
    let unitID = 26
    let name = "HC-4 Space Runway"
    let FP = 22.36
}

//2
struct Eliminator: Unit {
    let OF = 50
    let DF = 37
    let AT = 1
    let CA = -50
    let price = 10
    let CPX = 20
    let unitID = 27
    let name = "HEW-9 Eliminator"
    let FP = 0.89
}

//3
struct Megabot: Unit {
    let OF = 75
    let DF = 95
    let AT = 5
    let CA = 0
    let price = 250
    let CPX = 500
    let unitID = 27
    let name = "Megabot"
    let FP = 8.66
}

//4
struct Incinerator: Unit {
    let OF = 15
    let DF = 96
    let AT = 10
    let CA = 0
    let price = 35
    let CPX = 350
    let unitID = 29
    let name = "OSAA2 Incinerator"
    let FP = 6.12
}

//5
struct Raider: Unit {
    let FP = 0.56
    let OF = 25
    let DF = 20
    let AT = 1
    let CA = 0
    let price = 26
    let CPX = 25
    let unitID = 30
    let name = "X-5 Raider"
}

//6
struct Instigator: Unit {
    let FP = 0.68
    let OF = 35
    let DF = 25
    let AT = 1
    let CA = 0
    let price = 23
    let CPX = 25
    let unitID = 31
    let name = "X-6 Instigator"
}

//7
struct Corvette: Unit {
    let FP = 0.85
    let OF = 40
    let DF = 45
    let AT = 1
    let CA = 0
    let price = 23
    let CPX = 25
    let unitID = 32
    let name = "X-7 Corvette"
}

//8
struct Boron: Unit {
    let FP = 1.22
    let OF = 30
    let DF = 80
    let AT = 1
    let CA = -10
    let price = 22
    let CPX = 60
    let unitID = 33
    let name = "Boron Recon Buggy"
}

//9
struct Hurax: Unit {
    let FP = 3.16
    let OF = 60
    let DF = 88
    let AT = 2
    let CA = 0
    let price = 75
    let CPX = 250
    let unitID = 34
    let name = "Hurax Stealth Fighter"
}

//10
struct Thirus: Unit {
    let FP = 3.16
    let OF = 50
    let DF = 80
    let AT = 4
    let CA = 150
    let price = 150
    let CPX = 300
    let unitID = 35
    let name = "Thirus All-Purpose Saucer"
}

//11
struct Fighter: Unit {
    let FP = 0.62
    let OF = 30
    let DF = 22
    let AT = 1
    let CA = 0
    let price = 24
    let CPX = 25
    let unitID = 37
    let name = "Super Space Fighter"
}

//12
struct Giganto: Unit {
    let FP = 20.12
    let OF = 90
    let DF = 96
    let AT = 18
    let CA = 400
    let price = 210
    let CPX = 1000
    let unitID = 38
    let name = "Giganto Planet Attacker"
}

//13
struct Rover: Unit {
    let FP = 0.5
    let OF = 20
    let DF = 20
    let AT = 1
    let CA = 0
    let price = 5
    let CPX = 18
    let unitID = 39
    let name = "All-Terrain Rover"
}

//14
struct Wrecker: Unit {
    let FP = 34.64
    let OF = 40
    let DF = 99
    let AT = 30
    let CA = -300
    let price = 400
    let CPX = 2000
    let unitID = 40
    let name = "R-Class Wrecker"
}

//15
struct Battleship: Unit {
    let FP = 13.23
    let OF = 70
    let DF = 94
    let AT = 15
    let CA = 75
    let price = 225
    let CPX = 800
    let unitID = 41
    let name = "N-Class Battleship"
}

//16
struct Nozama: Unit {
    let FP = 0.64
    let OF = 17
    let DF = 17
    let AT = 2
    let CA = 0
    let price = 10
    let CPX = 20
    let unitID = 42
    let name = "Nozama Fighter"
}

//17
struct TkBike: Unit {
    let FP = 3.74
    let OF = 70
    let DF = 80
    let AT = 4
    let CA = 0
    let price = 125
    let CPX = 400
    let unitID = 43
    let name = "TK Bike"
}

//18
struct CrOrg: Unit {
    let FP = 23.09
    let OF = 80
    let DF = 97
    let AT = 20
    let CA = 0
    let price = 540
    let CPX = 1500
    let unitID = 44
    let name = "C.R. Org"
}

//19
struct Infinita: Unit {
    let FP = 50.99
    let OF = 65
    let DF = 99
    let AT = 40
    let CA = 20
    let price = 475
    let CPX = 4000
    let unitID = 45
    let name = "Infinita"
}

//20
struct Sentinel: Unit {
    let FP = 0.46
    let OF = 15
    let DF = 30
    let AT = 1
    let CA = -10
    let price = 12
    let CPX = 8
    let unitID = 46
    let name = "Sentinel of Garsasso"
}

//21
struct XironMediumCruiser: Unit {
    let FP = 10.95
    let OF = 50
    let DF = 95
    let AT = 12
    let CA = 120
    let price = 200
    let CPX = 450
    let unitID = 47
    let name = "Xiron Medium Cruiser"
}

//22
struct Scout: Unit {
    let FP = 0.91
    let OF = 50
    let DF = 40
    let AT = 1
    let CA = -15
    let price = 15
    let CPX = 30
    let unitID = 48
    let name = "ATO-2 Scout"
}

//23
struct Mauler: Unit {
    let FP = 1.7
    let OF = 50
    let DF = 48
    let AT = 3
    let CA = -30
    let price = 25
    let CPX = 65
    let unitID = 49
    let name = "A-7 Mauler"
}

//24
struct CrOrgII: Unit {
    let FP = 11.34
    let OF = 60
    let DF = 93
    let AT = 15
    let CA = -40
    let price = 200
    let CPX = 1000
    let unitID = 50
    let name = "C.R. Org II"
}

//25
struct TkTank: Unit {
    let FP = 1.76
    let OF = 65
    let DF = 79
    let AT = 1
    let CA = -20
    let price = 30
    let CPX = 85
    let unitID = 51
    let name = "TK Tank"
}

//26
struct OrnMoonGun: Unit {
    let FP = 47.96
    let OF = 100
    let DF = 99
    let AT = 23
    let CA = -1000
    let price = 400
    let CPX = 3000
    let unitID = 52
    let name = "Orn Moon Gun"
}

//27
struct Suicide: Unit {
    let FP = 4.26
    let OF = 90
    let DF = 1
    let AT = 20
    let CA = 0
    let price = 140
    let CPX = 600
    let unitID = 53
    let name = "E-Class Suicide Fighter"
}

//28
struct TkPsiHauler: Unit {
    let FP = 1.29
    let OF = 10
    let DF = 70
    let AT = 5
    let CA = 350
    let price = 175
    let CPX = 400
    let unitID = 54
    let name = "TK Psi Hauler"
}

//29
struct BoronV2: Unit {
    let FP = 1.65
    let OF = 30
    let DF = 89
    let AT = 1
    let CA = -12
    let price = 32
    let CPX = 100
    let unitID = 58
    let name = "Boron Recon Buggy v2"
}

//30
struct BoronV3: Unit {
    let FP = 3.87
    let OF = 60
    let DF = 92
    let AT = 2
    let CA = -15
    let price = 52
    let CPX = 140
    let unitID = 60
    let name = "Boron Recon Buggy v3"
}

//31
struct CROrgIIv2: Unit {
    let FP = 15.49
    let OF = 80
    let DF = 95
    let AT = 15
    let CA = -60
    let price = 250
    let CPX = 1400
    let unitID = 61
    let name = "C.R. Org II v2"
}

//32
struct CROrgIIv3: Unit {
    let FP = 23.8
    let OF = 85
    let DF = 97
    let AT = 20
    let CA = -60
    let price = 285
    let CPX = 1900
    let unitID = 63
    let name = "C.R. Org II v3"
}

//33
struct CROrgIIv4: Unit {
    let FP = 35.18
    let OF = 99
    let DF = 98
    let AT = 25
    let CA = -80
    let price = 2000
    let CPX = 2650
    let unitID = 66
    let name = "C. R. Org II v4"
}

//34
struct Annihilator: Unit {
    let FP = 3.46
    let OF = 60
    let DF = 75
    let AT = 5
    let CA = -75
    let price = 30
    let CPX = 100
    let unitID = 68
    let name = "HEW-10 Annihilator v2"
}

struct BattleshipV2: Unit {
    let FP = 18.97
    let OF = 90
    let DF = 95
    let AT = 20
    let CA = 50
    let price = 255
    let CPX = 1100
    let unitID = 72
    let name = "N-Class Batteship v2"
}

struct BattleStation: Unit {
    let FP = 36.74
    let OF = 90
    let DF = 98
    let AT = 30
    let CA = -200
    let price = 415
    let CPX = 1900
    let unitID = 72
    let name = "N-Class Battle Station v3"
}

struct TkBikeV2: Unit {
    let FP = 5.29
    let OF = 70
    let DF = 80
    let AT = 8
    let CA = 0
    let price = 185
    let CPX = 500
    let unitID = 74
    let name = "TK Bike v2"
}

struct ZenrinMonk: Unit {
    let FP = 0.23
    let OF = 5
    let DF = 2
    let AT = 1
    let CA = -1
    let price = 10
    let CPX = 10
    let unitID = 75
    let name = "Zenrin War Monk"
}

struct ZenrinFighter: Unit {
    let FP = 1.12
    let OF = 50
    let DF = 20
    let AT = 2
    let CA = -1
    let price = 25
    let CPX = 90
    let unitID = 77
    let name = "Zenrin Fighter v2"
}

struct ZenrinWarrior: Unit {
    let FP = 5.92
    let OF = 70
    let DF = 80
    let AT = 10
    let CA = -1
    let price = 100
    let CPX = 890
    let unitID = 79
    let name = "Zenrin Warrior v3"
}

struct ZenrinMaster: Unit {
    let FP = 40.0
    let OF = 100
    let DF = 98
    let AT = 32
    let CA = -1
    let price = 450
    let CPX = 8890
    let unitID = 81
    let name = "Zenrin Master v4"
}

struct MegaBotV2: Unit {
    let FP = 9.68
    let OF = 75
    let DF = 96
    let AT = 5
    let CA = 0
    let price = 315
    let CPX = 700
    let unitID = 83
    let name = "MegaBot v2"
}

struct MegaBotV3: Unit {
    let FP = 21.91
    let OF = 80
    let DF = 97
    let AT = 18
    let CA = 0
    let price = 390
    let CPX = 1700
    let unitID = 85
    let name = "MegaBot v3"
}

struct MegaBotV4: Unit {
    let FP = 47.43
    let OF = 90
    let DF = 98
    let AT = 50
    let CA = 0
    let price = 730
    let CPX = 5700
    let unitID = 87
    let name = "MegaBot v4"
}

struct Shuttle: Unit {
    let FP = 0.71
    let OF = 20
    let DF = 60
    let AT = 1
    let CA = 30
    let price = 20
    let CPX = 40
    let unitID = 88
    let name = "X-8 Assault Shuttle"
}

struct WarMek: Unit {
    let FP = 0.37
    let OF = 12
    let DF = 10
    let AT = 1
    let CA = -2
    let price = 12
    let CPX = 12
    let unitID = 89
    let name = "WarMek"
}

struct NozamaQueen: Unit {
    let FP = 4.47
    let OF = 40
    let DF = 90
    let AT = 5
    let CA = 0
    let price = 500
    let CPX = 500
    let unitID = 92
    let name = "Nozama Queen"
}

struct XironHeavyCruiserV2: Unit {
    let FP = 21.6
    let OF = 70
    let DF = 97
    let AT = 20
    let CA = 120
    let price = 300
    let CPX = 900
    let unitID = 94
    let name = "Xiron Heavy Cruiser v2"
}

struct Scuttler: Unit {
    let FP = 0.51
    let OF = 5
    let DF = 5
    let AT = 5
    let CA = -1
    let price = 9999
    let CPX = 25
    let unitID = 95
    let name = "Scuttler"
}

