//
//  UnlockViewController.swift
//  guessNumber
//
//  Created by Simon on 2018/4/7.
//  Copyright © 2018年 Simon. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController {
    //亂數
    var random = 0
    //剩餘時間
    var remainingNumber = 40
    //最大數字提示
    var maxNumber = 100
    //最小數字提示
    var minNumber = 0
    //判斷
    var timer: Timer?
    
    var side = 1
    
    var count = 0
    
    func judgment(number:Int){
        
        if number > 100{
            caveat(title: "錯誤", message: "輸入小於100的數字")
        }else if number > maxNumber {
            caveat(title: "錯誤", message: "就說了不要大於")
        }else if number < minNumber {
            caveat(title: "錯誤", message: "就說了不要小於")
        }else if number > random {         //猜的數字大於亂數
            maxNumber = number - 1
            rangeLabel.text = rangeHint()
            side += 1
        }else if number < random{          //猜的數字小於亂數
            minNumber = number + 1
            rangeLabel.text = rangeHint()
            side += 1
        }
        else if number == random
        {
            win()
        }
    }
    
    func win() {
        if side%2 == 1
        {
            caveat(title: "分出勝負了", message: "紅方猜中惹...黑方獲得勝利")
        //renew()
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
        else
        {
            caveat(title: "分出勝負了", message: "黑方猜中惹...紅方獲得勝利")
            //renew()
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
        side = 0
    }
    func loss(){
        if side%2 == 1
        {
            caveat(title: "時間到了", message: "紅方在時間內沒有猜")
            //renew()
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
        else
        {
            caveat(title: "時間到了", message: "黑方在時間內沒有猜")
            //renew()
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
        side = 0
    }
    
    func whoSize()
    {
        if side%2 == 1
        {
            roundLabel.text = "Red side"
        }
        else
        {
             roundLabel.text = "Black side"
        }
    }
    
    //警告控制器
    func caveat (title:String , message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    //重新開始
    func renew()  {
        random =  Int(arc4random_uniform(100))
        maxNumber = 100
        minNumber = 0
        rangeLabel.text = rangeHint()
        remainingNumber = 40
        remainingLabel.text = "\(remainingNumber)"
        count = 0
        side = 0
    }
    //重新開始
    @IBAction func againButton(_ sender: Any) {
        renew()
    }
    //提示範圍
    func rangeHint() -> String {
        return "\(minNumber)~\(maxNumber)"
    }
    //剩餘次數
    @IBOutlet weak var remainingLabel: UILabel!
    //範圍
    @IBOutlet weak var rangeLabel: UILabel!
    //使用者輸入
    @IBOutlet weak var numberTextField: UITextField!
    //go案妞
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBAction func goButon(_ sender: UIButton) {
         view.endEditing(true)
        if numberTextField.text == "" {                 //沒輸入就按按鈕
            caveat(title: "錯誤", message: "輸入小於100的數字")
        }else if Int(numberTextField.text!) == nil{     //輸入字串
            caveat(title: "只能輸入數字", message: nil)
        }else if remainingNumber > 0{                   //生命大於0
            let n = Int(numberTextField.text!)
            judgment(number: n!)
        }
        numberTextField.text = ""                       //每次按完按鈕把text field清空
        print("\(random)")
        whoSize()
    }
    var tap = 0
    //隱藏navigation bar 的方法
    @IBAction func tapGesture(_ sender: Any) {
        view.endEditing(true)
        if tap == 0{
            self.navigationController?.isNavigationBarHidden = false
            tap = 1
        }else if tap == 1 {
            self.navigationController?.isNavigationBarHidden = true
            tap = 0
        }                    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //隱藏navigation
        self.navigationController?.isNavigationBarHidden = true
        //取亂數
        random =  Int(arc4random_uniform(100))
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printtime), userInfo: nil, repeats: true)
        whoSize()
    }
    
    @objc func printtime () {
        remainingNumber -= 1
        remainingLabel.text = "\(remainingNumber)"
        if remainingNumber==0{                   //生命大於0
            loss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
