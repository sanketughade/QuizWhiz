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
    
    let brandView = UIView();
    
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
        
        questionCountPickerField.inputAccessoryView = createPickerToolbar(for: questionCountPickerField)
        categoryPickerField.inputAccessoryView = createPickerToolbar(for: categoryPickerField)
        difficultyPickerField.inputAccessoryView = createPickerToolbar(for: difficultyPickerField)
        
        questionPicker.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        
        addBrandView()
        layoutInputs()
        
        //Add tap animations
        startQuizButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        startQuizButton.addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            [self.brandView, self.questionCountPickerField, self.categoryPickerField, self.difficultyPickerField, self.startQuizButton].forEach { $0.applyAsymmetricBorder() }
        }
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
    
    @objc func closePicker() {
        view.endEditing(true) //Dismiss the keyboard or picker
    }
    
    //MARK: Input Setup
    func setupInput(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.backgroundColor = .white
        field.textColor = UIColor(hex: "#121212")
        field.font = UIFont(name: "AvenirNext-Medium", size: 18)
        field.layer.cornerRadius = 12
        field.borderStyle = .none
        
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
        button.titleLabel?.font = UIFont(name: "ComicNeue-Regular", size: 28)
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
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        //Set height constraint for each field
        [questionCountPickerField, categoryPickerField, difficultyPickerField, startQuizButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 55).isActive = true
        }
    }
    
    func createPickerToolbar(for textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(hex: "#b684df")
        toolbar.tintColor = .white
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closePicker))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        return toolbar
    }
}


