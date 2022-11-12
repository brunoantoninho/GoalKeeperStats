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
    
    var cameraUtils: CameraUtils!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupTextFields()
        setupNavigationBar()
        cameraUtils = CameraUtils()
        cameraUtils.delegate = self
    }
    
    private func setupButtons() {
        takePictureButton.addTarget(self, action: #selector(takePictureButtonAction), for: .touchUpInside)
    }
    
    private func setupTextFields() {
        playerNameTextField.becomeFirstResponder()
        playerAgeTextField.keyboardType = .numberPad
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
    }
    
    @objc
    private func takePictureButtonAction() {
        cameraUtils.showAddPhotoActionSheet()
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
            player.photo = playerImage.image?.jpegData(compressionQuality: 0.5)
//            player.gamePlayed = gamePlayed
            
            RealmManager().save(player)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreatePlayerViewController: CameraUtilsDelegate {
    func presentAddPhotoActionSheet(actionSheet: UIAlertController) {
        present(actionSheet, animated: true)
    }
    
    func presentImagePicker(imgPicker: UIImagePickerController) {
        present(imgPicker, animated: true)
    }
    
    func photoSelected(photo: UIImage) {
        playerImage.image = photo
        playerImage.isHidden = false
        self.dismiss(animated: true)
    }
}
