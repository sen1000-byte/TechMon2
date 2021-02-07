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
    @IBOutlet var playerTPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    //音楽再生などで使うクラス
    let techMonManager = TechMonManager.shared
    
    //インスタンス作成
    var player: Character!
    var enemy: Character!
    
    //ゲーム用タイマー
    var  gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    func updateUI() {
        //ステイタスの反映
        playerHPLabel.text = String(player.currentHP) + " / " + String(player.maxHP)
        playerMPLabel.text = String(player.currentMP) + " / " + String(player.maxMP)
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        enemyHPLabel.text = String(enemy.currentHP) + " / " + String(enemy.maxHP)
        enemyMPLabel.text = String(enemy.currentMP) + " / " + String(enemy.maxMP)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        enemyNameLabel.text = "ドラゴン"
        enemyImageView.image = UIImage(named: "monster.png")
        
        //TechMonManagerのインスタンスtechMonManagerを利用してTechMonManagerの中で作った情報を持つCharacterクラスを代入
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        //初期化
        player.resetStatus()
        enemy.resetStatus()
        
        
        updateUI()
        
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
    
    func judgeBattle() {
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        } else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @objc func updateGame() {
        player.currentMP += 1
        if player.currentMP >= 20 {
            isPlayerAttackAvailable = true
            player.currentMP = 20
        } else {
            isPlayerAttackAvailable = false
        }
        //敵のステータス
        enemy.currentMP += 1
        if enemy.currentMP >= 35 {
            enemyAttack()
            enemy.currentMP = 0
        }
        updateUI()
    }
    
    func enemyAttack() {
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        player.currentHP -= 20
        updateUI()
        judgeBattle()
    }
    
    @IBAction func attackAction() {
        if isPlayerAttackAvailable {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            enemy.currentHP = enemy.currentHP - 30
            player.currentMP = 0
            player.currentTP += 10
            if player.currentTP > player.maxTP {
                player.currentTP = player.maxTP
            }
            updateUI()
            judgeBattle()
        }
    }
    
    @IBAction func fire() {
        if isPlayerAttackAvailable && player.currentTP >= 40 {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0 {
                player.currentTP = 0
            }
            player.currentMP = 0
            updateUI()
            judgeBattle()
        }
    }
    
    @IBAction func tameru() {
        if isPlayerAttackAvailable {
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP {
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
