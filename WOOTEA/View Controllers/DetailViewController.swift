//
//  DetailViewController.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/7.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    var currentDrink: Drink!
    var selectedTemp: String = ""
    var selectedSweet: String = ""
    var selectedSize: String = ""
    var selectedTopping = [String]()
    var toppingAmount = 0
    var previousStepperValue = 1
    var count = 1 {
        didSet {
            countLabel.text = String(count)
        }
    }
    var totalAmount = 0 {
        didSet {
            TotalAmountLabel.text = "總金額: \(totalAmount)元"
        }
    }
    var loginName = ""
    
    @IBOutlet weak var oderScrollView: UIScrollView!
    @IBOutlet weak var DrinkName: UILabel!
    @IBOutlet weak var DrinkImageView: UIImageView!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet var TempButtons: [UIButton]!
    @IBOutlet var sweetButtons: [UIButton]!
    @IBOutlet var SizeButton: [UIButton]!
    @IBOutlet var ToppingButtons: [UIButton]!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var TempTopStackView: UIStackView!
    @IBOutlet weak var TempBottomStackView: UIStackView!
    @IBOutlet weak var sweetTopStackView: UIStackView!
    @IBOutlet weak var SweetBottomStackView: UIStackView!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setButtonsUI()
        updateData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            oderScrollView.contentInset = contentInsets
            oderScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        oderScrollView.contentInset = contentInsets
        oderScrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 此函數設置所有按鈕的UI
    func setButtonsUI() {
        TempButtons.forEach { setButtonStyle(button: $0) }
        sweetButtons.forEach { setButtonStyle(button: $0) }
        SizeButton.forEach {
            setButtonStyle(button: $0)
            if $0.tag == 31 {
                $0.setTitle("L\n+ 10", for: .normal)
                $0.titleLabel?.textAlignment = .center
                $0.titleLabel?.lineBreakMode = .byWordWrapping
            }
            
        }
        ToppingButtons.forEach {
            
            switch $0.tag {
            case 40:
                $0.setTitle("珍珠\n+ 10", for: .normal)
                break
            case 41:
                $0.setTitle("仙草凍\n+ 10", for: .normal)
                break
            case 42:
                $0.setTitle("綠茶凍\n+ 10", for: .normal)
                break
            case 43:
                $0.setTitle("小芋圓\n+ 15", for: .normal)
                break
            case 44:
                $0.setTitle("杏仁凍\n+ 15", for: .normal)
                break
            case 45:
                $0.setTitle("米漿凍\n+ 15", for: .normal)
                break
            case 46:
                $0.setTitle("豆漿凍\n+ 15", for: .normal)
                break
            case 47:
                $0.setTitle("奶霜(限冷飲)\n+ 20", for: .normal)
                break
            default:
                break
            }
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.lineBreakMode = .byWordWrapping
            setButtonStyle(button: $0)
        }
        let UserDefaults = UserDefaults.standard
        if let loginUserName = UserDefaults.string(forKey: "user") {
            loginName = loginUserName
            submitButton.setTitle("訂購", for: .normal)
            submitButton.layer.cornerRadius = 5
        } else {
            submitButton.setTitle("登入後\n訂購", for: .normal)
            submitButton.titleLabel?.textAlignment = .center
            submitButton.titleLabel?.lineBreakMode = .byWordWrapping
            submitButton.layer.cornerRadius = 5
        }
    }
    
    // 此函數設置給定按鈕的樣式
    func setButtonStyle(button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1)
        button.layer.cornerRadius = 5
    }
    
    func updateData() {
        DrinkName.text = currentDrink.name
        DrinkImageView.kf.setImage(with: currentDrink.imageUrl)
        DescriptionLabel.text = currentDrink?.description
        totalAmount = currentDrink.price
        userTextField.text = loginName
        
        // 更新溫度按鈕
        if !currentDrink.adjustableTemperature {
            updateButtons(for: TempButtons, in: TempTopStackView, withTitle: "溫度固定")
        }
        if !currentDrink.isHasHot {
            TempButtons[4].isHidden = true
            TempButtons[5].isHidden = true
            for index in 0...1  {
                replaceButtonWithPlaceholder(button: TempButtons[ 4 + index ], in: TempBottomStackView)
            }
        }
        
        // 更新甜度按鈕
        if !currentDrink.adjustableSweetness {
            updateButtons(for: sweetButtons, in: sweetTopStackView, withTitle: "甜度固定")
            SweetBottomStackView.isHidden = true
            let heightConstraint = SweetBottomStackView.heightAnchor.constraint(equalToConstant: 0)
            heightConstraint.isActive = true
        }
    }
    
    // 此函數基於它們的可調性更新一組按鈕的UI
    func updateButtons(for buttons: [UIButton], in stackView: UIStackView, withTitle title: String) {
        buttons.enumerated().forEach { (index, button) in
            if index > 0, index < 3 {
                replaceButtonWithPlaceholder(button: button, in: stackView)
            } else if index > 2 {
                button.removeFromSuperview()
            } else {
                button.setTitle(title, for: .normal)
            }
        }
    }
    
    // 此函數用占位符替換按鈕
    func replaceButtonWithPlaceholder(button: UIButton, in stackView: UIStackView) {
        button.removeFromSuperview()
        let newView = UIView()
        newView.backgroundColor = .white
        stackView.addArrangedSubview(newView)
    }
    
    // 新增此方法，根據 selectedTemp 來設定按鈕的選中狀態
    func updateTempButtonSelectionState() {
        
        if TempButtons[0].titleLabel?.text == "溫度固定"  {
            TempButtons[0].isSelected = selectedTemp == "正常冰"
        } else {
            TempButtons.forEach { button in
                button.isSelected = button.titleLabel?.text == selectedTemp || button.titleLabel?.text == selectedSweet
            }
        }
    }
    
    func updateSweetButtonSelectionState() {
        
        if sweetButtons[0].titleLabel?.text == "甜度固定" {
            sweetButtons[0].isSelected = selectedSweet == "正常糖"
        }
        else {
            sweetButtons.forEach { button in
                button.isSelected = button.titleLabel?.text == selectedTemp || button.titleLabel?.text == selectedSweet
            }
        }
    }
    
    // 修改 updateTempButtonBackgrounds() 方法
    func updateButtonBackgrounds(buutons: [UIButton]) {
        buutons.forEach { button in
            if button.isSelected {
                button.backgroundColor = UIColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1)
            } else {
                button.backgroundColor = .white
            }
        }
    }
    
    
    @IBAction func selectTemp(_ sender: UIButton) {
        if let temp = sender.titleLabel?.text {
            temp == "溫度固定" ? (selectedTemp = "正常冰") : (selectedTemp = temp)
        }
        updateTempButtonSelectionState()
        updateButtonBackgrounds(buutons:TempButtons)
    }
    
    @IBAction func selectSweet(_ sender: UIButton) {
        if let sweet = sender.titleLabel?.text {
            sweet == "甜度固定" ? (selectedSweet = "正常糖") : (selectedSweet = sweet)
        }
        updateSweetButtonSelectionState()
        updateButtonBackgrounds(buutons:sweetButtons)
    }
    
    @IBAction func selectSize(_ sender: UIButton) {
        
        let beforeSize = selectedSize
        selectedSize = sender.titleLabel?.text?.contains("M") ?? false ? "M" : "L"
        SizeButton.forEach { button in
            button.isSelected = button.titleLabel?.text?.contains(selectedSize) ?? false
        }
        updateButtonBackgrounds(buutons:SizeButton)
        
        if beforeSize == "L" {
            totalAmount -= 10
        }
        if selectedSize == "L" {
            totalAmount += 10
        }
        updateTotalAmount()
    }
    
    @IBAction func selectTopping(_ sender: UIButton) {
        if selectedTopping.count < 2 {
            toppingType(sender: sender)
        } else {
            ToppingButtons.forEach {
                $0.isSelected = false
                $0.backgroundColor = .white
            }
            selectedTopping.removeAll()
            totalAmount -= toppingAmount
            toppingAmount = 0
            toppingType(sender: sender)
        }
        updateTotalAmount()
    }
    
    func toppingType(sender: UIButton) {
        switch sender.tag {
        case 40:
            selectedTopping.append("珍珠")
            toppingAmount += 10
            totalAmount += 10
            break
        case 41:
            selectedTopping.append("仙草凍")
            toppingAmount += 10
            totalAmount += 10
            break
        case 42:
            selectedTopping.append("綠茶凍")
            toppingAmount += 10
            totalAmount += 10
            break
        case 43:
            selectedTopping.append("小芋圓")
            toppingAmount += 15
            totalAmount += 15
            break
        case 44:
            selectedTopping.append("杏仁凍")
            toppingAmount += 15
            totalAmount += 15
            break
        case 45:
            selectedTopping.append("米漿凍")
            toppingAmount += 15
            totalAmount += 15
            break
        case 46:
            selectedTopping.append("豆漿凍")
            toppingAmount += 15
            totalAmount += 15
            break
        case 47:
            selectedTopping.append("奶霜")
            toppingAmount += 20
            totalAmount += 20
            break
        default:
            totalAmount += 0
            break
        }
        print("選擇加料", selectedTopping)
        sender.isSelected = true
        sender.backgroundColor = UIColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1)
    }
    
    
    @IBAction func changeCount(_ sender: UIStepper) {
        if Int(sender.value) > previousStepperValue {
            print("增加", sender.value)
        } else {
            print("減少", sender.value)
        }
        
        count = Int(sender.value)
        updateTotalAmount()
        previousStepperValue = Int(sender.value)
    }
    
    func updateTotalAmount() {
        TotalAmountLabel.text = "總金額: \(totalAmount * count)元"
    }
    
    @IBAction func sendOder(_ sender: UIButton){
        print("loginName", loginName)
        print("loginVC", storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController ?? "???")
        if loginName == "", let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController {
            
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
            return
        }
        if !checkData() {
            return
        }
        let stringUrl = "https://api.airtable.com/v0/appE7K437QBucbxsg/order"
        guard let url = URL(string: stringUrl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer pat6aEQvRG1gPr3nI.15ffab2d4292ca7b9f3d676590f2289ef35be0e8292402762eeeb81e8fffa581", forHTTPHeaderField: "Authorization")
        
        
        
        let toppingOne = selectedTopping.count > 0 ? selectedTopping[0] : "無"
        let toppingTwo = selectedTopping.count > 1 ? selectedTopping[1] : "無"
        let user = userTextField.text?.isEmpty ?? true ? "匿名" : userTextField.text!
        
        let newOrder = Order(name: currentDrink.name, size: selectedSize, sugarLevel: selectedSweet, iceLevel: selectedTemp, toppingsOne: toppingOne, toppingsTwo: toppingTwo, totalAmount: Double(totalAmount), count: count, user: user)
        
        if let updateBody = try? JSONEncoder().encode(OrderPost(fields: newOrder)) {
            if let jsonString = String(data: updateBody, encoding: .utf8) {
                print("要上傳的: \(jsonString)")
            }
            urlRequest.httpBody = updateBody
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Error:", error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        _ = try JSONDecoder().decode(OrderPostResponse.self, from: data)
                        DispatchQueue.main.async {
                            showAlert(on: self, title: "訂購成功！", message: "\(self.currentDrink.name)\(self.count)杯", buttonTitle: "完成") { _ in
                                // 關閉當前頁
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                    } catch {
                        print(error)
                        showAlert(on: self, title: "訂購失敗！", message: "\(self.currentDrink.name)失敗", buttonTitle: "重新訂購") { _ in
                            // 關閉當前頁
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }.resume()
        } else {
            print("Failed to encode OrderPost.")
        }
        
        
    }
    func checkData() -> Bool {
        
        if selectedTemp.isEmpty {
            showAlert(on: self, title: "請選擇溫度", message: "", buttonTitle: "好的")
            return false
        }
        if selectedSweet.isEmpty {
            showAlert(on: self, title: "請選擇甜度", message: "", buttonTitle: "好的")
            return false
        }
        if selectedSize.isEmpty {
            showAlert(on: self, title: "請選擇尺寸", message: "", buttonTitle: "好的")
            return false
        }
        if userTextField.text?.isEmpty ?? true {
            showAlert(on: self, title: "請填寫訂購人", message: "", buttonTitle: "好的")
            return false
        }
        
        
        return true
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
