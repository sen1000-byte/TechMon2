//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Chihiro Nishiwaki on 2021/02/07.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    
    let techMonManager = TechMonManager.shared

    var stamina: Int = 100
    var staminaTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI設定
        nameLabel.text = "勇者"
        staminaLabel.text = String(stamina) + " / 100"

        //タイマーの設定
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateStaminaValue), userInfo: nil, repeats: true)
        staminaTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    //ロギー画面になるごとに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    //画面が見えなくなる時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @IBAction func toBattle() {
        if stamina >= 50 {
            stamina -= 50
            staminaLabel.text = String(stamina) + " / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else {
            let alert: UIAlertController = UIAlertController(title: "バトルに行けません", message: "スタミナが足りません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //スタミナの回復
    @objc func updateStaminaValue () {
        if stamina < 100{
            stamina = stamina + 1
            staminaLabel.text = "\(stamina) / 100"
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
