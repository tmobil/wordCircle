//
//  ViewController.swift
//  WordCircle
//
//  Created by Vamshi Krishna on 10/4/18.
//  Copyright © 2018 VamshiK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputValue: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputValue: UITextView!
    
    var circleWord : String = ""
    var wordDict : [String:Any] = [String:Any]()
    var sortedKeys: [String] = [String]()
    var sortedKeysArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "https://raw.githubusercontent.com/tmobil/WordCircle/master/english.json"
        getJsonDataFromUrl(url:jsonUrlString)
    }
    
    func getJsonDataFromUrl(url:String) {
        
        let spinner = startActivityIndicatorView()
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
            
            do {
                let wDict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                self.wordDict = wDict!
                
                //get all the keys
                self.sortedKeys = self.wordDict.keys.sorted()
                
                // convert all keys to lowercase and store
                for key in self.sortedKeys
                {
                    self.sortedKeysArray.append(key.lowercased())
                }
                
                self.stopActivityIndicatorView(activityView: spinner)
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
        
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        //getting input from Text Field
        let word = inputValue.text!
        circleWord = word.lowercased()
        
        // to check if inputed word is a valid word in the dictionary
        if (isWordValidFromDict(word: circleWord)) {
            
            outputValue.text = getOuputWords(word: circleWord)
        }
        else
        {
            let alert = UIAlertController(title: "Invalid word", message: "Not valid word from dictionary, choose another word", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func isWordValidFromDict(word: String) -> Bool {
        return sortedKeysArray.contains(word) && word.count >= 2
    }
    
    func getOuputWords(word: String) -> String? {
        var index = 0
        circleWord = word
        let prefix = String(circleWord.prefix(1))
        while circleWord.split(separator: " ").count <= (sortedKeysArray.count - 1) {
            if let wordFromDict = getWordStartWith(String(circleWord.suffix(1)), word: String(circleWord.split(separator: " ")[index])){
                circleWord += " " + wordFromDict
                index += 1
                
                // to make sure word circle has minimum 3 verticies
                if(wordFromDict.suffix(1) == prefix && circleWord.split(separator: " ").count >= 3)
                {
                    return circleWord
                }
            }
            else
            {
                let alert = UIAlertController(title: "Word circle not found", message: " Choose another word", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
                
                return " Word circle not found !! "
            }
        }
        
        return circleWord
    }
    
    
    
    // function to search and get the words from the dict to match the passed character
    func getWordStartWith(_ letter: String, word: String) -> String? {
        
        let wordCircleArray = circleWord.split(separator: " ")
        for key in self.sortedKeysArray {
            if key.starts(with: letter) && word != key && key.count >= 2 && !wordCircleArray.contains(Substring(key)) && key.containsOnlyAlphabets {
                return  key
            }
        }
        return nil
    }
    
    func startActivityIndicatorView() -> UIActivityIndicatorView {
        let x = (self.view.frame.width / 2)
        let y = (self.view.frame.height / 2)
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.frame = CGRect(x: 200, y: 120, width: 200, height: 200)
        activityView.center = CGPoint(x: x, y: y)
        activityView.color = UIColor.red
        activityView.isHidden = true
        activityView.startAnimating()
        self.view.addSubview(activityView)
        
        return activityView
    }
    
    func stopActivityIndicatorView(activityView: UIActivityIndicatorView) {
        DispatchQueue.main.async() {
            activityView.stopAnimating()
            activityView.hidesWhenStopped = true
        }
    }
    
}
