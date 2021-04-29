//
//  HomeViewController.swift
//  IOS-Calculadora
//
//  Created by Roger Orlando Ceres Salinas on 28/4/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    //Numeros
    @IBOutlet weak var numero0: UIButton!
    @IBOutlet weak var numero1: UIButton!
    @IBOutlet weak var numero2: UIButton!
    @IBOutlet weak var numero3: UIButton!
    @IBOutlet weak var numero4: UIButton!
    @IBOutlet weak var numero5: UIButton!
    @IBOutlet weak var numero6: UIButton!
    @IBOutlet weak var numero7: UIButton!
    @IBOutlet weak var numero8: UIButton!
    @IBOutlet weak var numero9: UIButton!
    @IBOutlet weak var numeroDecimal: UIButton!
    // Operadores
    @IBOutlet weak var operadorAC: UIButton!
    @IBOutlet weak var operadorMasMenos: UIButton!
    @IBOutlet weak var operadorPorciento: UIButton!
    @IBOutlet weak var operadorDividido: UIButton!
    @IBOutlet weak var operadorMultiplicar: UIButton!
    @IBOutlet weak var operadorRestar: UIButton!
    @IBOutlet weak var operadorSumar: UIButton!
    @IBOutlet weak var operadorIgual: UIButton!
    
    //MARK: - Variables
    private var total: Double = 0          //Total
    private var temp: Double = 0           //valor por pantalla
    private var operando = false           // indica si se ha seleccionado un operador
    private var decimal = false            //Indica si el valor es decimal
    private var operacion : OperacionTipo =  .ninguno //operacion actual
    
    //MARK: - Constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total"
    
    private enum OperacionTipo{
        case ninguno, suma, resta, multiplicacion, division, porciento
    }
    
    // Formateo de valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores auxiliares totales
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formateo de valores por pantalla en formato científico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    //MARK: - Initialization
        
    init() {
        super.init(nibName: nil, bundle: nil)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numeroDecimal.setTitle(kDecimalSeparator, for: .normal)
                
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UI
        numero0.round()
        numero1.round()
        numero2.round()
        numero3.round()
        numero4.round()
        numero5.round()
        numero6.round()
        numero7.round()
        numero8.round()
        numero9.round()
        numeroDecimal.round()
        
        operadorAC.round()
        operadorMasMenos.round()
        operadorPorciento.round()
        operadorDividido.round()
        operadorMultiplicar.round()
        operadorRestar.round()
        operadorSumar.round()
        operadorIgual.round()
    }
    
    //MARK: - Button Actions
    @IBAction func operadorACAction(_ sender: UIButton) {
        
        clear()
        sender.shine()
    }
    @IBAction func operadorMasMenosAction(_ sender: UIButton) {
        
        if total != 0{
            temp = total * (-1)
            total = total * (-1)
        }
        else{
            temp = temp * (-1)
        }
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    @IBAction func operadorPorcientoAction(_ sender: UIButton) {
        
        if operacion != .porciento {
            result()
        }
        operando = true
        operacion = .porciento
        result()
        
        sender.shine()
    }
    @IBAction func operadorDivididoAction(_ sender: UIButton) {
        
        if operacion != .ninguno {
            result()
        }
        
        operando = true
        operacion = .division
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operadorMultiplicarAction(_ sender: UIButton) {
        
        if operacion != .ninguno {
            result()
        }
        
        operando = true
        operacion = .multiplicacion
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operadorRestarAction(_ sender: UIButton) {
        
        if operacion != .ninguno {
            result()
        }
        
        operando = true
        operacion = .resta
        sender.selectOperation(true)

        sender.shine()
    }
    @IBAction func operadorSumarAction(_ sender: UIButton) {
        
        if operacion != .ninguno {
            result()
        }

        operando = true
        operacion = .suma
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operadorIgualAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    @IBAction func numeroDecimalAction(_ sender: UIButton) {
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if resultLabel.text?.contains(kDecimalSeparator) ?? false || (!operando && currentTemp.count >= kMaxLength) {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    @IBAction func numeroAction(_ sender: UIButton) {
        
        operadorAC.setTitle("C", for: .normal)
                
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operando && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Hemos seleccionado una operación
        if operando {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operando = false
        }
        
        // Hemos seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    //Limpia los valores
    private func clear(){
        if operacion == .ninguno{
            total = 0
        }
        operacion = .ninguno
        operadorAC.setTitle("AC", for: .normal)
        if temp != 0{
            temp = 0
            resultLabel.text = "0"
        }
        else{
            total = 0
            result()
        }
    }
    
    //obtiene el resultado final
    private func result(){
        switch operacion {
        
        case .ninguno:
            // No hacemos nada
            break
        case .suma:
            total = total + temp
            break
        case .resta:
            total = total - temp
            break
        case .multiplicacion:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .porciento:
            temp = temp / 100
            total = temp
            break
        }
        
        //Formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        }
        else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operacion = .ninguno
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        print("Total : \(total)")
    }
    
    // Muestra de forma visual la operación seleccionada
    private func selectVisualOperation() {
        
        if !operando {
            // No estamos operando
            operadorSumar.selectOperation(false)
            operadorRestar.selectOperation(false)
            operadorMultiplicar.selectOperation(false)
            operadorDividido.selectOperation(false)
        }
        else {
            switch operacion {
            case .ninguno, .porciento:
                operadorSumar.selectOperation(false)
                operadorRestar.selectOperation(false)
                operadorMultiplicar.selectOperation(false)
                operadorDividido.selectOperation(false)
                break
            case .suma:
                operadorSumar.selectOperation(true)
                operadorRestar.selectOperation(false)
                operadorMultiplicar.selectOperation(false)
                operadorDividido.selectOperation(false)
                break
            case .resta:
                operadorSumar.selectOperation(false)
                operadorRestar.selectOperation(true)
                operadorMultiplicar.selectOperation(false)
                operadorDividido.selectOperation(false)
                break
            case .multiplicacion:
                operadorSumar.selectOperation(false)
                operadorRestar.selectOperation(false)
                operadorMultiplicar.selectOperation(true)
                operadorDividido.selectOperation(false)
                break
            case .division:
                operadorSumar.selectOperation(false)
                operadorRestar.selectOperation(false)
                operadorMultiplicar.selectOperation(false)
                operadorDividido.selectOperation(true)
                break
            }
        }
    }
    
}
