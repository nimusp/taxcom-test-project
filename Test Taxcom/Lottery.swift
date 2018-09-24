//
//  Lottery.swift
//  Test Taxcom
//
//  Created by Pavel Sumin on 23.09.2018.
//  Copyright © 2018 For Myself Inc. All rights reserved.
//

import Foundation

enum LotteryStatus {
    case intro
    case firstDoorWasOpen
    case secondDoorWasOpen
}

class Lottery {
    private var doors: [Door] = []
    private(set) var selectedDoorIndex = -1
    private(set) var carIndex = -1
    private(set) var goatIndex = -1
    private(set) var withoutChangeWinsCounter = 0
    private(set) var onChangeWinsCounter = 0
    private(set) var text = ""
    private(set) var status: LotteryStatus = .intro
    private(set) var getTrophy = false
    
    func raffleSeveralTimes(_ times: Int, callback: @escaping () -> Void) {
        var counter = times
        onChangeWinsCounter = 0
        withoutChangeWinsCounter = 0
        
        //remove UI locking while loop
        DispatchQueue.global(qos: .userInitiated).async {
            while counter > 0 {
                self.setupLottery()
                self.checkPrimarySelection()
                self.checkChangedSelection()
                counter -= 1
            }
            
            //interaction with UI only in main thread
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    func selectDoor(_ doorIndex: Int) {
        switch status {
        case .firstDoorWasOpen:
            if doorIndex == selectedDoorIndex {
                checkPrimarySelection()
            } else {
                checkChangedSelection()
                selectedDoorIndex = doorIndex
            }
            openSecondDoor()
            
        default:
            selectedDoorIndex = doorIndex
            doors[selectedDoorIndex].setSelected()
            openFirstDoor()
        }
    }
    
    func setupLottery() {
        text = "За одной из этих трёх дверей приз." +
        "\nПопытайте удачу и выберите одну из дверей."
        
        doors = []
        for _ in 0 ..< 3 {
            doors.append(Door())
        }
        
        selectedDoorIndex = Int.random(in: 0 ..< doors.count)
        let random = Int.random(in: 0 ..< doors.count)
        carIndex = random
        doors[carIndex].putSecret(.car)
        
        status = .intro
    }
    
    //player not changed the door
    private func checkPrimarySelection() {
        if doors[selectedDoorIndex].secret == .car {
            withoutChangeWinsCounter += 1
        }
    }
    
    //player changed the door
    private func checkChangedSelection () {
        var closedDoors = doors
        
        //change selection and remove wrong door
        closedDoors.remove(at: selectedDoorIndex)
        guard let goatIndex = closedDoors.firstIndex(where: {$0.secret == .goat}) else { return }
        closedDoors.remove(at: goatIndex)
        
        if closedDoors.first?.secret == .car {
            onChangeWinsCounter += 1
        }
    }
    
    private func openFirstDoor() {
        guard let falseDoorIndex = doors.firstIndex(where: {$0.secret == .goat && !$0.isSelected}) else { return }
        text = "Вы выбрали дверь номер \(selectedDoorIndex + 1)." +
        "\nЗа дверью номер \(falseDoorIndex + 1) находилась коза. Вы можете изменить свой выбор." +
        "\nВыберите дверь окончательно."
        goatIndex = falseDoorIndex
        doors[goatIndex].openDoor()
        status = .firstDoorWasOpen
    }
    
    private func openSecondDoor() {
        text = "Придерживаясь первоначального выбора, вы выиграли \(withoutChangeWinsCounter) раз(а)." +
            "\nВыбирая другую дверь, вы выиграли \(onChangeWinsCounter) раз(а)."
        var closedDoors = doors
        closedDoors.remove(at: selectedDoorIndex)
        guard let goatDoorIndex = closedDoors.firstIndex(where: {$0.secret == .goat && !$0.isSelected}) else { return }
        closedDoors.remove(at: goatDoorIndex)
        
        //if last door with goat
        //(first door with goar and right selected door with car were removed)
        getTrophy = closedDoors.first?.secret != .car ? true : false
        status = .secondDoorWasOpen
    }
}
