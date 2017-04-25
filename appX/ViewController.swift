//
//  ViewController.swift
//  appX
//
//  Created by user on 28.03.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import JSQWebViewController
import UIColor_Hex_Swift

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableNumbersInTest: UITableView!
    @IBOutlet weak var enterAnswer: UITextField!
    @IBOutlet weak var imageQuestion: UIImageView!
    @IBOutlet weak var imageAnswer: UIImageView!
    @IBOutlet weak var seeSolution: UIButton!
    @IBOutlet weak var checkTest: UIButton!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var referenceData: UIButton!
    
    //просмотр видео на ютуб
    @IBAction func seeSolution(_ sender: UIButton) {
        //print((test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].url)! as String)
        //self.performSegue(withIdentifier: "segueForWebView", sender: nil)
        let controller = WebViewController(url: URL(string: (test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].url)!)!)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
    //кнопка Проверить
    @IBAction func nextClick(_ sender: UIButton) {
        seeSolution.isHidden = false
        test?.isVerified = true
        imageAnswer.image = test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].imageAnswer
        tableNumbersInTest.reloadData()
    }
    
    @IBAction func exitClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showReferenceData(_ sender: UIButton) {
        showFullscreenImage(nil)
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if currentCell.indexRow >= 0 && currentCell.indexSect >= 0 {
            swipeTask(section: &currentCell.indexSect, row: &currentCell.indexRow, direction: sender.direction.rawValue)
        }
    }
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if currentCell.indexRow >= 0 && currentCell.indexSect >= 0 {
            swipeTask(section: &currentCell.indexSect, row: &currentCell.indexRow, direction: sender.direction.rawValue)
        }
    }
    
    var test: TestEGE?
    var str = String()
    var currentCell = CurrentCellTable()
    
    var scrollView: UIScrollView!
    var vieww: UIView!
    var newImageView: UIImageView!
    
    func dateForTask(inPart: Int, numberTask: Int) {
        if let test = test {
            imageQuestion.image = test.arrayOfTasks[inPart][numberTask].imageQuestion
            //newImageView = UIImageView(image: imageQuestion.image)
            if test.isVerified {
                imageAnswer.image = test.arrayOfTasks[inPart][numberTask].imageAnswer
            }
            if test.arrayOfTasks[inPart][numberTask].arrayOfAnswers.first == "no answer" {
                enterAnswer.isHidden = true
                labelAnswer.isHidden = true
            } else {
                enterAnswer.isHidden = false
                labelAnswer.isHidden = false
                enterAnswer.text = test.arrayOfTasks[inPart][numberTask].enteredAnswers
            }
            tableNumbersInTest.reloadData()
        }
    }
    
    func swipeTask(section: inout Int, row: inout Int, direction: UInt) {
        if let test = test {
            //константа number - количество задач в часте минус 1
            let number = test.arrayOfTasks[section].count - 1
            switch (row, number) {
            case (0, 0):
                (direction == 1) && (section < test.arrayOfTasks.count - 1) ? (section += 1) : (section += 0)
                (direction == 2) &&  (section > 0) ? (section -= 1) : (section -= 0)
            case (0, _) where direction == 1:
                row += 1
            case (0, _) where (direction == 2) && (section > 0):
                section -= 1
                row = test.arrayOfTasks[section].count - 1
            case (number, _) where (direction == 1) && (section < test.arrayOfTasks.count - 1):
                section += 1
                row = 0
            case (number, _) where direction == 2:
                row -= 1
            case (1..<number, _):
                direction == 1 ? (row += 1) : (row -= 1)
            default:
                print("switch swipe error")
                break
            }
            dateForTask(inPart: section, numberTask: row)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterAnswer.text != "" {
            test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].answerSelection = "+"
            test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].enteredAnswers = enterAnswer.text!
        } else {
            test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].answerSelection = ""
            test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].enteredAnswers = enterAnswer.text!
        }
        tableNumbersInTest.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        //test = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        print("asdasdads")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFullscreenImage))
        imageQuestion.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(showFullscreenImage))
        imageAnswer.addGestureRecognizer(tap1)
        
        checkTest.isHidden = true
        seeSolution.isHidden = true
        labelAnswer.isHidden = true
        
        enterAnswer.delegate = self
        
        let hud = PKHUD()
        hud.contentView = PKHUDProgressView(title: "Загружаем тест", subtitle: "")
        hud.show()
        
        FIRDatabase.database().reference().child(str).observe(FIRDataEventType.value, with:
        { (snapshot) in
            guard let quantityParts = snapshot.value as? NSDictionary else { print("quantityParts"); return }
            self.test = TestEGE(json: quantityParts, idTest: self.str)!
            if let test = self.test {
                FIRStorage.storage().reference().child(self.str + "/referenceData.png").data(withMaxSize: 1 * 1024 * 1024)
                {data, error in
                    if error != nil {
                    } else {
                        self.referenceData.isHidden = false
                        self.test?.referenceData = UIImage(data: data!)!
                    }
                }
                
                FIRStorage.storage().reference().child(self.str + "/description.png").data(withMaxSize: 1 * 1024 * 1024)
                {data, error in
                    if error != nil {
                    } else {
                        self.imageQuestion.image = UIImage(data: data!)
                    }
                }
                
                for partNumber in 1...test.numberParts{
                    for taskNumber in 1...test.arrayOfTasks[partNumber - 1].count {
                        FIRStorage.storage().reference().child(test.arrayOfTasks[partNumber - 1][taskNumber - 1].wayForImageQuestion).data(withMaxSize: 1 * 1024 * 1024)
                        {data, error in
                            if error != nil {
                            } else {
                                self.test?.arrayOfTasks[partNumber - 1][taskNumber - 1].imageQuestion = UIImage(data: data!)!
                                
                                if (self.test?.arrayOfTasks.last?.last?.imageQuestion.size.width)! > 0 {
                                    hud.hide(true)
                                    self.tableNumbersInTest.reloadData()
                                }
                            }
                        }
                        FIRStorage.storage().reference().child(test.arrayOfTasks[partNumber - 1][taskNumber - 1].wayForImageAnswer).data(withMaxSize: 1 * 1024 * 1024)
                        {data, error in
                            if error != nil {
                            } else {
                                self.test?.arrayOfTasks[partNumber - 1][taskNumber - 1].imageAnswer = UIImage(data: data!)!
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueForWebView" {
            let testsViewController = segue.destination as! WebViewController1
            testsViewController.url1 = (test?.arrayOfTasks[currentCell.indexSect][currentCell.indexRow].url)!//"tests/ege/physics"
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    func showFullscreenImage(_ sender: UITapGestureRecognizer?) {
        vieww = UIView(frame: self.view.frame)
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.frame = self.view.frame
        scrollView.backgroundColor = .black
        scrollView.isUserInteractionEnabled = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        swipeDown.direction = .down
        swipeUp.direction = .up
        scrollView.addGestureRecognizer(swipeDown)
        scrollView.addGestureRecognizer(swipeUp)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
 
        if let imageView = sender?.view as? UIImageView {
            guard let image = imageView.image else { return }
            newImageView = UIImageView(image: image)
        } else {
            newImageView = UIImageView(image: test?.referenceData)
        }
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        vieww.addSubview(scrollView)
        scrollView.addSubview(newImageView)
        self.view.addSubview(vieww)
    }
    
    func dismissFullscreenImage(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down || sender.direction == .up {
            newImageView = UIImageView(image: imageQuestion.image)
            vieww.removeFromSuperview()
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return newImageView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let test = test {
            return test.numberParts
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let test = test {
            return test.arrayOfTasks[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 28)
        let header = UIView(frame: frame)
        header.backgroundColor = UIColor.darkGray
        let ter = UILabel(frame: frame)
        ter.textAlignment = .center
        ter.font = UIFont(name: "Futura", size: 11)
        ter.textColor = UIColor.white
        if section == 0 {
            ter.text = "1 часть"
        } else if section == 1 {
            ter.text = "2 часть"
        }
        header.addSubview(ter)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNumberInTheTest", for: indexPath) as! TableNumbersInTest
        
        if let test = test {
            cell.numberLabel.text = test.arrayOfTasks[section][row].numberInTest
            cell.completedLabel.text = test.arrayOfTasks[section][row].answerSelection
            if test.isVerified {
                for value in (test.arrayOfTasks[section][row].arrayOfAnswers) {
                    if test.arrayOfTasks[section][row].enteredAnswers == value {
                        cell.backgroundColor = UIColor("#0fff17")
                        cell.numberLabel.textColor = UIColor.black
                        break
                    } else if test.arrayOfTasks[section][row].enteredAnswers == "" {
                        cell.backgroundColor = UIColor("#fced3f")
                        cell.numberLabel.textColor = UIColor.black
                    } else {
                        cell.backgroundColor = UIColor("#ff0000")
                        cell.numberLabel.textColor = UIColor.black
                    }
                }
            }
            return cell
        } else {
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section

        labelAnswer.isHidden = false
        checkTest.isHidden = false
        currentCell.indexSect = section
        currentCell.indexRow =  row
        
        dateForTask(inPart: section, numberTask: row)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (currentCell.indexRow == indexPath.row) && (currentCell.indexSect == indexPath.section) {
        cell.setSelected(true, animated: false)
        }
    }
}



