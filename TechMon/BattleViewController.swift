//
//  BattleViewController.swift
//  TechMon
//
//  Created by 坂口 友吾 on 2022/08/05.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var PlayerMPLabel: UILabel!
    @IBOutlet var PlayerTPLabel: UILabel!
    
    
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!
    var isPlayerAttackAvailabel: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        resetStatus()
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
       
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
       
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
        
        // Do any additional setup after loading the view.
    }
    

    func resetStatus() {
        
        player.currentHP = player.maxHP
        player.currentTP = 0
        player.currentMP = 0
        
        enemy.currentHP = enemy.maxHP
        enemy.currentTP = 0
        enemy.currentMP = 0
        
        
    }
    
    
    
    
    
    func updateUI(){
          
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        PlayerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        PlayerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
        
        
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        
    }
    
    func judgeBattle() {
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
        
        player.currentMP += 1
        if player.currentMP >= 20{
            isPlayerAttackAvailabel = true
            player.currentMP = 20
        }else{
            isPlayerAttackAvailabel = false
        }
            
        enemy.currentMP += 1
        if enemy.currentMP >= 35{
            
            enemyAttack()
            enemy.currentMP = 0
        }
            
        updateUI()
        
        
        judgeBattle()
        
        
        
        
    }
    
    func enemyAttack(){
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        
        judgeBattle()
          

        
        
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailabel = false
        
        var finishMessage: String = ""
        if isPlayerWin{
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利"
            
        }else{
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北"
            
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
             _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
    }
        
           @IBAction func attackAction() {
             
            if isPlayerAttackAvailabel{
                techMonManager.damageAnimation(imageView: enemyImageView)
                techMonManager.playSE(fileName: "SE_attack")
                
                enemy.currentHP -= player.attackPoint
                
                player.currentTP += 10
                if player.currentTP >= player.maxTP{
                    player.currentTP = player.maxTP
                }
                
                player.currentMP = 0
                
            
                judgeBattle()
                
                
            }
             
             
        }
        
         @IBAction func tameruAction() {
        
             if isPlayerAttackAvailabel {
                 techMonManager.playSE(fileName: "SE_charge")
                 player.currentTP += 40
                 if player.currentTP >= player.maxTP{
                     player.currentTP = player.maxTP
                 }
                 player.currentMP = 0
                 
             }
         }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailabel && player.currentTP >= 40{
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            enemy.currentHP -= 100
            
            player.currentTP -= 40
            
            
            if player.currentTP <= 0 {
                player.currentTP = 0
                
            }
            
            player.currentMP = 0
            
            judgeBattle()
            
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
