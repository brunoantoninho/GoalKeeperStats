//
//  CreateTeamViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 11/11/2022.
//

import Photos
import UIKit

class CreateTeamViewController: UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamAddress: UITextField!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var teamPhoto: UIImageView!
    
    private let viewModel = SelectTeamViewModel()
    weak var selectTeamdelegate: SelectTeamProtocol?
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
        teamNameTextField.becomeFirstResponder()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
    }
    
    @objc
    private func saveButtonAction() {
        
        if let teamName = teamNameTextField.text,
           let teamAddress = teamAddress.text {
            
            let team = Team()
            team.id = Int(Date().timeIntervalSince1970 * 1000)
            team.name = teamName
            team.address = teamAddress
            team.photo = teamPhoto.image?.jpegData(compressionQuality: 0.5)
            
            //  team.gamesList = List<Game>()
            
            RealmManager().save(team)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func takePictureButtonAction() {
        cameraUtils.showAddPhotoActionSheet()
    }
}

extension CreateTeamViewController: CameraUtilsDelegate {
    func presentAddPhotoActionSheet(actionSheet: UIAlertController) {
        present(actionSheet, animated: true)
    }
    
    func presentImagePicker(imgPicker: UIImagePickerController) {
        present(imgPicker, animated: true)
    }
    
    func photoSelected(photo: UIImage) {
        teamPhoto.image = photo
        teamPhoto.isHidden = false
        self.dismiss(animated: true)
    }
}
