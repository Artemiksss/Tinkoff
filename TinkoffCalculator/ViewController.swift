//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Артём Жовнир on 2024-01-26.
//

import UIKit

enum CalculationError : Error {
    case dividedByZero
}
enum Operation : String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate (_ number1 : Double, _ number2 : Double) throws -> Double {
        switch self{
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if (number2 == 0){
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
    
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonTitle = sender.titleLabel?.text {
            if buttonTitle == "," && lable.text?.contains(",") == true {
                return
            }
            if lable.text == "0" {
                lable.text = buttonTitle
            } else {
                lable.text?.append(buttonTitle)
            }
        }
    }
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        if let buttonTitle = sender.titleLabel?.text {
            guard
                let buttonOperation = Operation(rawValue: buttonTitle),
                let lableText = lable.text,
                let lableNumber = numberFormatter.number(from: lableText)?.doubleValue
                else { return }
            calculationHistory.append(.number(lableNumber))
            calculationHistory.append(.operation(buttonOperation))
            lable.text = ""
        }
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        resetLableText()
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let lableText = lable.text,
            let lableNumber = numberFormatter.number(from: lableText)?.doubleValue
            else { return }
        calculationHistory.append(.number(lableNumber))
        do{
            let result = try calculate()
            lable.text = numberFormatter.string(from: NSNumber(value: result))
        }catch{
            lable.text = "Ошибка"
        }
        calculationHistory.removeAll()
    }
    
    
    
    
    
    var calculationHistory : [CalculationHistoryItem] = []
    @IBOutlet var lable: UILabel!
    
    lazy var numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    func calculate() throws -> Double{
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        
        }
        return currentResult
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLableText()
    }
    
    func resetLableText(){
        lable.text = "0"
    }
    func numberResetLableText(_ number : String){
        lable.text = number
    }
}

