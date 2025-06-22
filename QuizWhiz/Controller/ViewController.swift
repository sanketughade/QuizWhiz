//
//  ViewController.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 25/05/25.
//

import UIKit
import Lottie

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
    let categories = [
        (id: 9,  name: "General Knowledge"),
        (id: 10, name: "Entertainment: Books"),
        (id: 11, name: "Entertainment: Film"),
        (id: 12, name: "Entertainment: Music"),
        (id: 13, name: "Entertainment: Musicals & Theatres"),
        (id: 14, name: "Entertainment: Television"),
        (id: 15, name: "Entertainment: Video Games"),
        (id: 16, name: "Entertainment: Board Games"),
        (id: 17, name: "Science & Nature"),
        (id: 18, name: "Science: Computers"),
        (id: 19, name: "Science: Mathematics"),
        (id: 20, name: "Mythology"),
        (id: 21, name: "Sports"),
        (id: 22, name: "Geography"),
        (id: 23, name: "History"),
        (id: 24, name: "Politics"),
        (id: 25, name: "Art"),
        (id: 26, name: "Celebrities"),
        (id: 27, name: "Animals"),
        (id: 28, name: "Vehicles"),
        (id: 29, name: "Entertainment: Comics"),
        (id: 30, name: "Science: Gadgets"),
        (id: 31, name: "Entertainment: Japanese Anime & Manga"),
        (id: 32, name: "Entertainment: Cartoon & Animations")
      ]
    let difficulties = ["Easy", "Medium", "Hard"]
    
    var categoryId: Int?
    
    var backgroundOverlay: UIView!

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
    
    /// Called when the user touches down on the Start Quiz button.
    /// Shrinks the button slightly and darkens the background to give tap feedback.
    @objc func touchDown(_ sender: UIButton) {
        //This function is called when the button is pressed
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            sender.backgroundColor = UIColor(hex: "#a370d3") // slightly darker
        }
    }
    
    /// Called when the user lifts their finger off the Start Quiz button
    /// or when the tap is canceled. Resets the button to its original style.
    @objc func touchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.backgroundColor = UIColor(hex: "#b684df")
            self.startQuizLoading()
        }
    }
    
    @objc func closePicker() {
        view.endEditing(true) //Dismiss the keyboard or picker
    }
    
    @objc func dismissCustomAlert(_ sender: UIButton) {
        if let overlay = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.2, animations: {
                overlay.alpha = 0
            }) { _ in
                overlay.removeFromSuperview()
            }
        }
    }
    
    func startQuizLoading() {
        backgroundOverlay = UIView(frame: view.bounds)
        backgroundOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(backgroundOverlay)
        
        let whiteContainer = UIView()
        whiteContainer.backgroundColor = .white
        whiteContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundOverlay.addSubview(whiteContainer)
        
        NSLayoutConstraint.activate([
            whiteContainer.centerXAnchor.constraint(equalTo: backgroundOverlay.centerXAnchor),
            whiteContainer.centerYAnchor.constraint(equalTo: backgroundOverlay.centerYAnchor),
            whiteContainer.widthAnchor.constraint(equalToConstant: 220),
            whiteContainer.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        DispatchQueue.main.async {
            whiteContainer.applyAsymmetricBorder()
        }
        
        let loadingAnimationView = LottieAnimationView(name: "quiz_loading_animation")
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        whiteContainer.addSubview(loadingAnimationView)
        
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: whiteContainer.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: whiteContainer.centerYAnchor),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: 200),
            loadingAnimationView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        loadingAnimationView.play()
        
        startQuizPressed()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.backgroundOverlay.removeFromSuperview()
//            self.startQuizPressed()
//        }
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
    
    func startQuizPressed() {
        if isQuizDetailsValid() {
            QuizService.fetchQuestions(
                numberOfQuestions: questionCountPickerField.text!,
                categoryId: categoryId!,
                difficulty: difficultyPickerField.text!
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let questions):
                        self.backgroundOverlay.removeFromSuperview()
                        if questions.count == 0 {
                            self.showCustomAlert(message: "No questions found for the selected category.")
                        } else {
                            self.performSegue(withIdentifier: "goToQuiz", sender: questions)
                        }
                        
                    case .failure(let error):
                        self.backgroundOverlay.removeFromSuperview()
                        self.showCustomAlert(message: "Failed to load quiz: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuiz",
           let destination = segue.destination as? QuizViewController,
           let questions = sender as? [QuizQuestion] {
            destination.quizQuestions = questions
        }
    }
    
    func showCustomAlert(message: String) {
        //Dimmed background
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.alpha = 0
        view.addSubview(overlayView)
        
        //Alert Box
        let alertBox = UIView()
        alertBox.translatesAutoresizingMaskIntoConstraints = false
        alertBox.backgroundColor = UIColor(hex: "#fff8e1")
        overlayView.addSubview(alertBox)
        
        NSLayoutConstraint.activate([
            alertBox.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            alertBox.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            alertBox.widthAnchor.constraint(equalToConstant: 280),
            alertBox.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        //Message Label
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = UIColor(hex: "#d32f2f")
        messageLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        alertBox.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -16)
        ])
        
        //Dismiss Button
        let dismissButton = UIButton(type: .system)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Git it!", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = UIColor(hex: "#b684df")
        dismissButton.titleLabel?.font = UIFont(name: "Fredoka", size: 16)
        alertBox.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            dismissButton.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20)
        ])
        
        //Dismiss Logic
        dismissButton.addTarget(self, action: #selector(dismissCustomAlert(_:)), for: .touchUpInside)
        
        //Add border to alert box
        alertBox.layoutIfNeeded()
        alertBox.applyAsymmetricBorder()
        
        //Animate in
        UIView.animate(withDuration: 0.25) {
            overlayView.alpha = 1
        }
        
        //Store refernece for dismissal
        overlayView.tag = 999
        
    }
    
    private func isQuizDetailsValid() -> Bool {
        if questionCountPickerField.text?.isEmpty ?? true {
            showCustomAlert(message: "Please select number of questions")
            return false
        } else if categoryPickerField.text?.isEmpty ?? true {
            showCustomAlert(message: "Please select the category")
            return false
        } else if difficultyPickerField.text?.isEmpty ?? true {
            showCustomAlert(message: "Please select the difficulty")
            return false
        }
        return true
    }
}


