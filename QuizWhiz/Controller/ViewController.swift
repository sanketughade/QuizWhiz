//
//  ViewController.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 25/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: UI Elements
    
    let questionCountPickerField = UITextField()
    let categoryPickerField = UITextField()
    let difficultyPickerField = UITextField()
    
    let questionPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    let difficultyPicker = UIPickerView()
    
    let startQuizButton = UIButton()
    
    let questionCount = ["10", "20", "50", "100"]
    let categories = ["General Knowledge", "Entertainment", "Science", "History"]
    let difficulties = ["Easy", "Medium", "Hard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#f3f2e9")
        
        setupInput(questionCountPickerField, placeholder: "Number of Questions")
        setupInput(categoryPickerField, placeholder: "Select Category")
        setupInput(difficultyPickerField, placeholder: "Select Difficulty")
        setupStartQuizButton(startQuizButton)
        
        questionCountPickerField.inputView = questionPicker
        categoryPickerField.inputView = categoryPicker
        difficultyPickerField.inputView = difficultyPicker
        
        questionPicker.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        
        layoutInputs()
        
        //Add tap animations
        startQuizButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        startQuizButton.addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            [self.questionCountPickerField, self.categoryPickerField, self.difficultyPickerField, self.startQuizButton].forEach { self.applyAsymmetricBorder(to: $0) }
        }
    }
    
    //MARK: Input Setup
    func setupInput(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.backgroundColor = .white
        field.textColor = UIColor(hex: "#121212")
        field.font = UIFont(name: "AvenirNext-Medium", size: 18)
        field.layer.cornerRadius = 12
        field.borderStyle = .none
        field.delegate = self
        
        //Add padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        field.leftView = padding
        field.leftViewMode = .always
        field.rightView = padding
        field.rightViewMode = .always
    }
    
    //MARK: Start Quiz Button
    func setupStartQuizButton(_ button: UIButton) {
        button.setTitle("Start Quiz 🚀", for: .normal)
        button.setTitleColor(UIColor(hex: "#f3f2e9"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Bangers", size: 22)
        button.backgroundColor = UIColor(hex: "#b684df")
        button.layer.masksToBounds = false
        
        //Padding inside button text
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
    }
    
    
    //MARK: Layout
    func layoutInputs() {
        let stackView = UIStackView(arrangedSubviews: [
            questionCountPickerField,
            categoryPickerField,
            difficultyPickerField,
            startQuizButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setCustomSpacing(30, after: questionCountPickerField)
        stackView.setCustomSpacing(30, after: categoryPickerField)
        stackView.setCustomSpacing(50, after: difficultyPickerField)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        //Set height constraint for each field
        [questionCountPickerField, categoryPickerField, difficultyPickerField, startQuizButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 55).isActive = true
        }
    }
    
    func applyAsymmetricBorder(to view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == "border" })
        
        let color = UIColor(hex: "#121212").cgColor
        
        let top = CALayer()
        top.name = "border"
        top.backgroundColor = color
        top.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        
        let left = CALayer()
        left.name = "border"
        left.backgroundColor = color
        left.frame = CGRect(x: 0, y: 0, width: 1, height: view.frame.height)
        
        let right = CALayer()
        right.name = "border"
        right.backgroundColor = color
        right.frame = CGRect(x: view.frame.width - 4, y: 0, width: 4, height: view.frame.height)
        
        let bottom = CALayer()
        bottom.name = "border"
        bottom.backgroundColor = color
        bottom.frame = CGRect(x: 0, y: view.frame.height - 4, width: view.frame.width, height: 4)
        
        [top, left, right, bottom].forEach { view.layer.addSublayer($0) }
    }
    
    @objc func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            sender.backgroundColor = UIColor(hex: "#a370d3") // slightly darker
        }
    }
    
    @objc func touchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.backgroundColor = UIColor(hex: "#b684df")
        }
    }


}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == questionPicker {
            return questionCount.count
        } else if pickerView == categoryPicker {
            return categories.count
        } else {
            return difficulties.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == questionPicker {
            return questionCount[row]
        } else if pickerView == categoryPicker {
            return categories[row]
        } else {
            return difficulties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == questionPicker {
            questionCountPickerField.text = questionCount[row]
        }
        else if pickerView == categoryPicker {
            categoryPickerField.text = categories[row]
        } else {
            difficultyPickerField.text = difficulties[row]
        }
    }
}

extension ViewController: UIPickerViewDataSource {
    
}


