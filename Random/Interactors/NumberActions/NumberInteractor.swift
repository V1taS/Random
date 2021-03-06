//
//  NumberInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol NumberInteractor {
    func generateNumber(state: Binding<AppState.AppData>)
    func cleanNumber(state: Binding<AppState.AppData>)
    func saveNumberToUserDefaults(state: Binding<AppState.AppData>)
}

struct NumberInteractorImpl: NumberInteractor {
    
    func saveNumberToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveListResult(state: state)
            saveListRandomNumber(state: state)
            saveNoRepetitions(state: state)
            saveFirstNumber(state: state)
            saveSecondNumber(state: state)
            saveResult(state: state)
        }
    }
    
    func generateNumber(state: Binding<AppState.AppData>) {
        if takefromNumberInt(state: state) < taketoNumberInt(state: state) {
            switch state.numberRandom.noRepetitions.wrappedValue {
            case true:
                noRepetitionsNumbers(state: state)
            case false:
                repetitionsNumbers(state: state)
            }
        }
    }
    
    func cleanNumber(state: Binding<AppState.AppData>) {
        state.numberRandom.result.wrappedValue = "?"
        state.numberRandom.listResult.wrappedValue = []
        state.numberRandom.listRandomNumber.wrappedValue = []
    }
}

extension NumberInteractorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom
                                    .listResult.wrappedValue,
                                  forKey: "NumberViewListResult")
    }
    
    private func saveListRandomNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom
                                    .listRandomNumber.wrappedValue,
                                  forKey: "NumberViewListRandomNumber")
    }
    
    private func saveNoRepetitions(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom
                                    .noRepetitions.wrappedValue,
                                  forKey: "NumberViewNoRepetitions")
    }
    
    private func saveFirstNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom.firstNumber.wrappedValue,
                                  forKey: "NumberViewFirstNumber")
    }
    
    private func saveSecondNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom.secondNumber.wrappedValue,
                                  forKey: "NumberViewSecondNumber")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.numberRandom
                                    .result.wrappedValue,
                                  forKey: "NumberViewResult")
    }
}

extension NumberInteractorImpl {
    private func takefromNumberInt(state: Binding<AppState.AppData>) -> Int {
        var fromNumberInt: Int = 0
        if let fromNumber = Int(state.numberRandom.firstNumber.wrappedValue) {
            fromNumberInt = fromNumber
        }
        return fromNumberInt
    }
}

extension NumberInteractorImpl {
    private func taketoNumberInt(state: Binding<AppState.AppData>) -> Int {
        var toNumberInt: Int = 0
        if let toNumber = Int(state.numberRandom.secondNumber.wrappedValue) {
            toNumberInt = toNumber
        }
        return toNumberInt
    }
}

extension NumberInteractorImpl {
    private func generateListRandomNumber(from fromNumberInt: Int,
                                  to toNumberInt: Int,
                                  state: Binding<AppState.AppData>) {
        
        for num in fromNumberInt...toNumberInt {
            let numStr = "\(num)"
            state.numberRandom.listRandomNumber.wrappedValue.append(numStr)
        }
    }
}

extension NumberInteractorImpl {
    private func shuffledistRandomNumber(state: Binding<AppState.AppData>) {
        state.numberRandom.listRandomNumber.wrappedValue.shuffle()
    }
}

extension NumberInteractorImpl {
    private func takeNumberFromList(state: Binding<AppState.AppData>) {
        if state.numberRandom.listRandomNumber.wrappedValue.count != 0 {
            state.numberRandom.result.wrappedValue = "\(state.numberRandom.listRandomNumber.wrappedValue.first!)"
            state.numberRandom.listResult.wrappedValue.insert("\(state.numberRandom.listRandomNumber.wrappedValue.first!)", at: 0)
            state.numberRandom.listRandomNumber.wrappedValue.removeFirst()
        }
    }
}

extension NumberInteractorImpl {
    private func noRepetitionsNumbers(state: Binding<AppState.AppData>) {
        if state.numberRandom.result.wrappedValue == "?" {
            generateListRandomNumber(from: takefromNumberInt(state: state),
                                     to: taketoNumberInt(state: state),
                                     state: state)
            shuffledistRandomNumber(state: state)
            takeNumberFromList(state: state)
        } else {
            takeNumberFromList(state: state)
        }
    }
}

extension NumberInteractorImpl {
    private func repetitionsNumbers(state: Binding<AppState.AppData>) {
        let fromNumberInt = takefromNumberInt(state: state)
        let toNumberInt = taketoNumberInt(state: state)
        let randomInt = Int.random(in: fromNumberInt...toNumberInt)
        
        if state.numberRandom.listResult.wrappedValue.count < toNumberInt {
            state.numberRandom.listResult.wrappedValue.insert("\(randomInt)", at: 0)
            state.numberRandom.result.wrappedValue = "\(randomInt)"
        }
    }
}

