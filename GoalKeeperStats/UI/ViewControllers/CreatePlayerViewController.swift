//
//  AddPlayerViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 08/11/2022.
//

import UIKit

class CreatePlayerViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerAgeTextField: UITextField!
    @IBOutlet weak var playerSectionTextField: UITextField!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    private func setupButtons() {
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonAction() {
        
        if let playerName = playerNameTextField.text,
           let playerAge = Int(playerAgeTextField.text!),
           let playerSection = playerSectionTextField.text {
            
            let player = Player()
            player.id = Int(Date().timeIntervalSince1970 * 1000)
            player.name = playerName
            player.age = playerAge
            player.section = playerSection
//            player.photo = photo
//            player.gamePlayed = gamePlayed
            
            RealmManager().save(player)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
