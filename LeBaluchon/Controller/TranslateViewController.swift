//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 27/07/2023.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var targetLanguageButton: UIButton!

    @IBOutlet weak var translateButton: UIButton!

    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var targetTextView: UITextView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// TapGestureRecognizer to dismiss the keyboard when tapping outside UITextView.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        self.showActivityIndicator(show: false)
        
        /// Executed when the language target is changed, handled by each item of the menu.
        let targetOptionsClosure = { (action: UIAction) in
            switch self.targetLanguageButton.title(for: .normal) {
            case "English":
                TranslateService.shared.targetLanguage = "en"
            case "Spanish":
                TranslateService.shared.targetLanguage = "es"
            case "Japanese":
                TranslateService.shared.targetLanguage = "ja"
            default:
                TranslateService.shared.targetLanguage = "en"
            }
            self.translate() // Automatically translates when the target language is changed.
        }
        
        /// Creates items corresponding to languages to add them in the menu.
        var targetLanguagesChildren: [UIAction] = []
        for language in TranslateService.shared.languages {
            targetLanguagesChildren.append(UIAction(title: language, state: language == "English" ? .on : .off, handler: targetOptionsClosure))
        }
        targetLanguageButton.menu = UIMenu(children: targetLanguagesChildren)
    }
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        showActivityIndicator(shown: true)
        translate()
    }
    
    /// Executed when the translateButton is tapped.
    /// 
    private func translate() {
        if let text = sourceTextView.text {
            TranslateService.shared.expressionToTranslate = text // Save the expression to translate.
        } else {
            self.presentAlert(title: "Erreur", message: "Erreur lors de la récupération du texte")
        }
        TranslateService.shared.getTranslation { (success, translation) in
            self.showActivityIndicator(shown: false)
            if success, let translation = translation {
                self.targetTextView.text = translation.getTranslation() // Display the translation.
            } else {
                self.presentAlert(title: "Erreur", message: "Erreur lors de la traduction")
            }
        }
    }

    /// Used to hide/show the UIAtivityIndicatorView and the UITextFields.
    private func showActivityIndicator(show: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !show
    }

    /// Present an UIAlertController with a custom title and message.
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
