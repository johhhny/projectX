//
//  TestClass.swift
//  appX
//
//  Created by user on 05.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import Firebase

struct Task {
    var numberInTest = String()
    var imageQuestion = UIImage()
    var imageAnswer = UIImage()
    var url = String()
    var enteredAnswers = String()
    var answerSelection = String()
    var arrayOfAnswers = [String]()
    var wayForImageQuestion = String()
    var wayForImageAnswer = String()
}

class TestEGE {
    var numberParts = Int()
    var arrayOfTasks = [[Task]]()
    var isVerified = false
    var referenceData = UIImage()
    
    init?(json: NSDictionary, idTest: String) {
        self.numberParts = json.count - 2
        var counterForTaskNumber = 0
        for partNumber in 1...json.count - 2 {
            
            guard let part = json["part\(partNumber)"] as? NSDictionary else { print("part"); return }
            self.arrayOfTasks.append(Array(repeatElement(Task(), count: part.count)))
            
            for taskNumber in 1...part.count {
                var arrayOfAnswers = [String]()
                counterForTaskNumber += 1

                guard let task = part["task\(taskNumber)"] as? NSDictionary else { print("task"); return }
                guard let url = task["url"] as? String else { print("url"); return }
                guard let question = task["question"] as? String else { print("question"); return }
                guard let answers = task["answers"] as? Array<String> else { print("answers"); return }

                for value in answers {
                    arrayOfAnswers.append(value)
                }
                
                self.arrayOfTasks[partNumber - 1][taskNumber - 1].numberInTest = String(counterForTaskNumber)
                self.arrayOfTasks[partNumber - 1][taskNumber - 1].arrayOfAnswers = arrayOfAnswers
                self.arrayOfTasks[partNumber - 1][taskNumber - 1].url = url
                self.arrayOfTasks[partNumber - 1][taskNumber - 1].wayForImageQuestion = idTest + "/questions/" + question
                self.arrayOfTasks[partNumber - 1][taskNumber - 1].wayForImageAnswer = idTest + "/answers/" + question
            }
        }
    }
    
    convenience init()  {
        self.init()
    }
}

struct CurrentCellTable {
    var indexSect = -1
    var indexRow = -1
}


/*
 FIRStorage.storage().reference().child(idTest + "/questions/" + question).data(withMaxSize: 1 * 1024 * 1024)
 {data, error in
 if error != nil {
 } else {
 self.arrayOfTasks[partNumber - 1][taskNumber - 1].imageQuestion = UIImage(data: data!)!
 }
 }*/
/*FIRStorage.storage().reference().child(idTest + "/answers/" + question).data(withMaxSize: 1 * 1024 * 1024)
 {data, error in
 if error != nil {
 } else {
 self.arrayOfTasks[partNumber - 1][taskNumber - 1].imageAnswer = UIImage(data: data!)!
 }
 }*/
