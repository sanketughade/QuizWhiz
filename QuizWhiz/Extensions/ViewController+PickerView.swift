//
//  ViewController+PickerView.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 01/06/25.
//

import UIKit

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            return categories[row].name
        } else {
            return difficulties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == questionPicker {
            questionCountPickerField.text = questionCount[row]
        }
        else if pickerView == categoryPicker {
            categoryId = categories[row].id
            categoryPickerField.text = categories[row].name
        } else {
            difficultyPickerField.text = difficulties[row]
        }
    }
}
