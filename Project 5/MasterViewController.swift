//
//  MasterViewController.swift
//  Project 5
//
//  Created by Tendai Prince Dzonga on 1/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var allWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt"){
            do{
            let startWords = try NSString(contentsOfFile: startWordsPath, usedEncoding: nil)
                allWords = startWords.componentsSeparatedByString("\n")
            }catch _{}
        }else{
            allWords = ["silkworm"]
            
        }
        
        startGame()
        
    }
    
    func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        let submitAction = UIAlertAction(title: "Submit", style: .Default){ [unowned self, ac] (action: UIAlertAction!) in
            let answer = ac.textFields![0]
            self.submitAnswer(answer.text!)
        }
        
        ac.addAction(submitAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String){
        
        let lowerAnswer = answer.lowercaseString
        
        let errorTitle: String
        let errorMessage: String
        
        if wordIsPossible(lowerAnswer){
            if wordIsOriginal(lowerAnswer){
                if wordIsReal(lowerAnswer){
                    objects.insert(answer, atIndex: 0)
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    return
                }
                else{
                    errorTitle = "Words not recognized"
                    errorMessage = "You can't just make them up you know"
                }
            }
            else{
                errorTitle = "Words used already"
                errorMessage = "Be more original"
            }
        }
        else{
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that from '\(title!.lowercaseString)'!"
            
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func wordIsPossible(word: String) -> Bool{
        var tempWord = title!.lowercaseString
        for letter in word.characters{
            if let pos = tempWord.rangeOfString(String(letter)){
                tempWord.removeAtIndex(pos.startIndex)
            }else{
                return false
            }
        }
        return true
    }
    
    
    func wordIsOriginal(word: String) -> Bool{
        return !objects.contains(word)
    }
    
    func wordIsReal(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
        
    }
    

    func startGame(){
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues


    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

}





