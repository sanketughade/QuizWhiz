//
//  QuizViewController.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 08/06/25.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    var quizQuestions: [QuizQuestion] = []
    var optionComponents: [OptionComponents] = []
    var isAnswerSelected = false
    let questionLabel = UILabel()
    let optionsStackView = UIStackView()
    var prevButton = UIButton()
    var nextButton = UIButton()
    var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#f3f2e9")
        loadQuestionOptionsUI()
        loadPreviousNextButtons()
    }
    
    func loadQuestionOptionsUI() {
        let questionView = UIView()
        questionView.translatesAutoresizingMaskIntoConstraints = false
        questionView.backgroundColor = UIColor(hex: "#dbc2ef")
        view.addSubview(questionView)
        
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            questionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = decodeHTMLEntities(quizQuestions[0].question)
        print(quizQuestions[0].question)
        questionLabel.textColor = UIColor(hex: "#121212")
        questionLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        questionLabel.textAlignment = .left
        questionLabel.numberOfLines = 0
        
        questionView.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 10),
            questionLabel.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -10),
            questionLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -12)
        ])
        
        
        //Create stackview to hold the options
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 20
        optionsStackView.distribution = .fillEqually
        view.addSubview(optionsStackView)
        
        //Create option views(2 or 4 depending on your case)
        let optionTitles = getRandomizedOptions(correctOption: quizQuestions[currentQuestionIndex].correct_answer, incorrectOptions: quizQuestions[currentQuestionIndex].incorrect_answers)
        
        var optionViews: [UIView] = []
        var circleViews: [UIView] = []
        
        for title in optionTitles {
            let optionView = UIView()
            optionView.backgroundColor = UIColor(hex: "#b3e0ff")
            //Set a tag or use index to identify the option
            optionView.tag = optionViews.count
            
            //Add tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            optionView.isUserInteractionEnabled = true
            optionView.addGestureRecognizer(tap)
            
            //Create the circle indicator
            let circleView = UIView()
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.backgroundColor = UIColor(hex: "#f3f2e9")
            circleView.layer.cornerRadius = 10
            circleView.layer.borderWidth = 2
            circleView.layer.borderColor = UIColor(hex: "#121212").cgColor
            circleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            circleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            circleViews.append(circleView)
            
            //Create a label
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.textColor = UIColor(hex: "#121212")
            label.font = UIFont(name: "AvenirNext-Medium", size: 16)
            label.textAlignment = .left
            label.numberOfLines = 0
            
            //Horizontal stack to hold circle and label
            let innerStack = UIStackView(arrangedSubviews: [circleView, label])
            innerStack.translatesAutoresizingMaskIntoConstraints = false
            innerStack.axis = .horizontal
            innerStack.spacing = 12
            innerStack.alignment = .center
            
            optionView.addSubview(innerStack)
            
            NSLayoutConstraint.activate([
                innerStack.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 12),
                innerStack.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: -12),
                innerStack.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
                innerStack.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -16)
            ])
            
            optionsStackView.addArrangedSubview(optionView)
            optionViews.append(optionView)
            
            optionComponents.append(OptionComponents(view: optionView, label: label, circle: circleView))
            
            
        }
        
        //Stack view constraints (positioned below questionView)
        NSLayoutConstraint.activate([
            optionsStackView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 50),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            optionsStackView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        DispatchQueue.main.async {
            questionView.applyAsymmetricBorder()
            circleViews.forEach { $0.backgroundColor = UIColor(hex: "#f3f2e9")
                $0.layer.cornerRadius = 10
                $0.layer.masksToBounds = true
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor(hex: "#121212").cgColor
            }
            optionViews.forEach { $0.applyAsymmetricBorder() }
        }
    }
    
    func loadPreviousNextButtons() {
        prevButton = getPreviousAndNextButtons("← Prev 🧭")
        nextButton = getPreviousAndNextButtons("🎯 Next →")
        
        let prevNextStackView = UIStackView(arrangedSubviews: [prevButton, nextButton])
        prevNextStackView.axis = .horizontal
        prevNextStackView.distribution = .equalSpacing
        prevNextStackView.alignment = .center
        prevNextStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(prevNextStackView)
        
        NSLayoutConstraint.activate([
            prevNextStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prevNextStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            prevNextStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            prevNextStackView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        prevButton.addTarget(self, action: #selector(prevTouchDown(_:)), for: .touchDown)
        prevButton.addTarget(self, action: #selector(prevTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        nextButton.addTarget(self, action: #selector(nextTouchDown), for: .touchDown)
        nextButton.addTarget(self, action: #selector(nextTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        
        DispatchQueue.main.async {
            self.prevButton.applyAsymmetricBorder()
            self.nextButton.applyAsymmetricBorder()
            
            //Disable prev and next buttons as the currentQuestionIndex is 0
            self.disableButton(self.prevButton)
            self.disableButton(self.nextButton)
        }
    }
    
    private func getPreviousAndNextButtons(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "#ffbd59"), for: .normal)
        button.titleLabel?.font = UIFont(name: "ComicNeue-Bold", size: 22)
        button.backgroundColor = UIColor(hex: "#b684df")
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        
        button.layer.masksToBounds = false
        
        //Add padding inside button
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        
        return button
    }
    
    private func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.alpha = 0.4
    }
    
    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.alpha = 1.0
    }
    
    @objc func optionTapped(_ sender: UITapGestureRecognizer) {
        
        if isAnswerSelected { return }
        
        isAnswerSelected = true
        
        guard let tappedView = sender.view else { return }
        
        guard let selected = optionComponents.first(where: { $0.view == tappedView }) else { return }
        
        let selectedAnswer = selected.label.text ?? ""
        let correctAnswer = quizQuestions[currentQuestionIndex].correct_answer
        
        for option in optionComponents {
            let isCorrect = option.label.text == correctAnswer
            let isSelected = option.view == tappedView
            
            //Reset any previous emoji
            option.circle.subviews.forEach { $0.removeFromSuperview() }
            
            if isCorrect {
                //Correct Answer
                option.view.backgroundColor = UIColor(hex: isSelected ? "#c8e6c9" : "e8f5e9")
                
                let tick = UILabel()
                tick.text = "✅"
                tick.translatesAutoresizingMaskIntoConstraints = false
                option.circle.addSubview(tick)
                NSLayoutConstraint.activate([
                    tick.centerXAnchor.constraint(equalTo: option.circle.centerXAnchor),
                    tick.centerYAnchor.constraint(equalTo: option.circle.centerYAnchor)
                ])
            } else if isSelected {
                option.view.backgroundColor = UIColor(hex: "ffcdd2")
                
                let cross = UILabel()
                cross.text = "❌"
                cross.translatesAutoresizingMaskIntoConstraints = false
                option.circle.addSubview(cross)
                NSLayoutConstraint.activate([
                    cross.centerXAnchor.constraint(equalTo: option.circle.centerXAnchor),
                    cross.centerYAnchor.constraint(equalTo: option.circle.centerYAnchor)
                ])
            } else {
                option.view.backgroundColor = UIColor(hex: "b3e0ff")
            }
        }
        if (currentQuestionIndex < quizQuestions.count - 1) {
            enableButton(nextButton)
        }
    }
    
    @objc func prevTouchDown(_ sender: UIButton) {
        touchDownAnimation(sender)
    }
    
    @objc func prevTouchUp(_ sender: UIButton) {
        touchUpAnimation(sender)
        updateQuestionAndOptions(isNext: false)
    }
    
    @objc func nextTouchDown(_ sender: UIButton) {
        touchDownAnimation(sender)
    }
    
    @objc func nextTouchUp(_ sender: UIButton) {
        touchUpAnimation(sender)
        updateQuestionAndOptions()
    }
    
    private func touchDownAnimation(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            button.backgroundColor = UIColor(hex: "#a370d3")
        }
    }
    
    private func touchUpAnimation(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = .identity
            button.backgroundColor = UIColor(hex: "#b684df")
        }
    }
    
    private func getRandomizedOptions(correctOption: String, incorrectOptions: [String]) -> [String] {
        var options = incorrectOptions;
        options.append(correctOption)
        return options.shuffled();
    }
    
    private func updateQuestionAndOptions(isNext: Bool = true) {
        if isNext {
            currentQuestionIndex += 1
        } else {
            currentQuestionIndex -= 1
        }
        
        isAnswerSelected = false
        
        let currentQuestion = quizQuestions[currentQuestionIndex]
        
        questionLabel.text = currentQuestion.question
        
        let randomizedOptions = getRandomizedOptions(correctOption: currentQuestion.correct_answer, incorrectOptions: currentQuestion.incorrect_answers)
        
        for (i, option) in optionComponents.enumerated() {
            if i < randomizedOptions.count {
                option.label.text = randomizedOptions[i]
                option.view.backgroundColor = UIColor(hex: "#b3e0ff")
                option.circle.subviews.forEach { $0.removeFromSuperview() }
            }
        }
        
        if currentQuestionIndex == 0 {
            disableButton(prevButton)
        } else {
            enableButton(prevButton)
        }
        
        if isNext || currentQuestionIndex == quizQuestions.count - 1 {
            disableButton(nextButton)
        } else {
            enableButton(nextButton)
        }
        
        
    }
    
    private func decodeHTMLEntities(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#039;", with: "'")
            .replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }
    
    
}
