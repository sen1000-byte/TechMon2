//
//  BattleViewController.swift
//  TechMon
//
//  Created by Chihiro Nishiwaki on 2021/02/07.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    //音楽再生などで使うクラス
    let techMonManager = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    //ゲーム用タイマー
    var  gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = String(playerHP) + " / 100"
        playerMPLabel.text = String(playerMP) + " / 20"

        enemyNameLabel.text = "ドラゴン"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = String(enemyHP) + " / 200"
        enemyMPLabel.text = String(enemyMP) + " / 35"
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame() {
        playerMP += 1
        if playerMP >= 20 {
            isPlayerAttackAvailable = true
            playerMP = 20
        } else {
            isPlayerAttackAvailable = false
        }
        //敵のステータス
        enemyMP += 1
        if enemyMP >= 35 {
            enemyAttack()
            enemyMP = 0
        }
        playerMPLabel.text = "\(playerMP) / 20"
        enemyMPLabel.text = "\(enemyMP) / 35"
    }
    
    func enemyAttack() {
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        playerHP -= 20
        playerHPLabel.text = String(playerHP) + " / 100"
        if playerHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利!"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: false, completion: nil)
    }
    
    @IBAction func attackAction() {
        if isPlayerAttackAvailable {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            enemyHP = enemyHP - 30
            playerMP = 0
            enemyHPLabel.text = "\(enemyHP) / 200"
            playerMPLabel.text = "\(playerMP) / 20"
            if enemyHP <= 0 {
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
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
