//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 27/07/2023.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var targetLanguageButton: UIButton!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var targetTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        activityIndicator.isHidden = true
        
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
            self.translate()
        }
        
        var targetLanguagesChildren: [UIAction] = []
        for language in TranslateService.shared.languages {
            targetLanguagesChildren.append(UIAction(title: language, state: language == "English" ? .on : .off, handler: targetOptionsClosure))
        }
        targetLanguageButton.menu = UIMenu(children: targetLanguagesChildren)
    }
    
    private func presentAlert(title: String, message: String) {
          let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        toggleActivityIndicator(shown: true)
        translate()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        translateButton.isHidden = shown
    }
    
    private func translate() {
        if let text = sourceTextView.text {
            TranslateService.shared.expressionToTranslate = text
        } else {
            self.presentAlert(title: "Erreur", message: "Erreur lors de la récupération du texte")
        }
        TranslateService.shared.getTranslation { (success, translation) in
            self.toggleActivityIndicator(shown: false)
            if success, let translation = translation {
                self.targetTextView.text = translation.getTranslation()
            } else {
                self.presentAlert(title: "Erreur", message: "Erreur lors de la traduction")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
