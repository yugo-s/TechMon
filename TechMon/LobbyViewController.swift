//
//  LobbyViewController.swift
//  TechMon
//
//  Created by 坂口 友吾 on 2022/08/05.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet var namelabel: UILabel!
    @IBOutlet var staminalabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        namelabel.text = "勇者"
        staminalabel.text = "\(stamina) / 100"
        
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStaminaValue), userInfo: nil, repeats: true)
        staminaTimer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    @IBAction func toBattle(){
        if stamina >= 50{
            
            stamina -= 50
            staminalabel.text = "\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert: UIAlertController = UIAlertController(title: "バトルに行けません", message: "スタミナが足りません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina += 1
            staminalabel.text = "\(stamina)"
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
