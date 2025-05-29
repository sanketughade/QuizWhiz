//
//  ViewController.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 25/05/25.
//

import UIKit

class QuizSetupViewController: UIViewController {
    
    //MARK: UI Elements
    
    let questionCountField = UITextField()
    let categoryPickerField = UITextField()
    let difficultyPickerField = UITextField()
    
    let categoryPicker = UIPickerView()
    let difficultyPicker = UIPickerView()
    
    let categories = ["General Knowledge", "Entertainment", "Science", "History"]
    let difficulties = ["Easy", "Medium", "Hard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#f32e9")
        
        setupInput(questionCountField, placeholder: "Number of Questions")
        setupInput(categoryPickerField, placeholder: "Select Category")
        setupInput(difficultyPickerField, placeholder: "Select Difficulty")
        
        categoryPickerField.inputView = categoryPicker
        difficultyPickerField.inputView = difficultyPicker
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        
        layoutInputs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [questionCountField, categoryPickerField, difficultyPickerField].forEach { applyAsymmetricBorder(to: $0) }
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
        view.addSubview(field)
    }
    
    //MARK: Layout
    func layoutInputs() {
        let inputs = [questionCountField, categoryPickerField, difficultyPickerField]
        
        for (i, field) in inputs.enumerated() {
            field.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                field.heightAnchor.constraint(equalToConstant: 55),
                field.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(60 + i * 80))
            ])
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


}

//MARK: - UITextFieldDelegate
extension QuizSetupViewController: UITextFieldDelegate {
    
}

//MARK: - UIPickerViewDelegate
extension QuizSetupViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == categoryPicker ? categories.count : difficulties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == categoryPicker ? categories[row] : difficulties[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryPickerField.text = categories[row]
        } else {
            difficultyPickerField.text = difficulties[row]
        }
    }
}

extension QuizSetupViewController: UIPickerViewDataSource {
    
}


