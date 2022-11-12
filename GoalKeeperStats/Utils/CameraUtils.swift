//
//  Utils.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 12/11/2022.
//

import UIKit

protocol CameraUtilsDelegate: AnyObject {
    func presentAddPhotoActionSheet(actionSheet: UIAlertController)
    func presentImagePicker(imgPicker: UIImagePickerController )
    func photoSelected(photo: UIImage)
}

class CameraUtils: NSObject {
    
    weak var delegate: CameraUtilsDelegate?
    
    func showAddPhotoActionSheet() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.showImagePickerController(sourceType: .camera)
        }
        alert.addAction(takePhotoAction)
        
        let existingPhotoAction = UIAlertAction(title: "Fotos", style: .default) { alertAction in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        alert.addAction(existingPhotoAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        delegate?.presentAddPhotoActionSheet(actionSheet: alert)
    }
    
    private func showImagePickerController(sourceType: UIImagePickerController.SourceType){
        DispatchQueue.main.async { [self] in
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = true
            imgPicker.sourceType = sourceType
            imgPicker.presentationController?.delegate = self
            delegate?.presentImagePicker(imgPicker: imgPicker)
        }
    }
}

extension CameraUtils: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Library photo
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            if let imageData = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: imageData) {
                    delegate?.photoSelected(photo: image)
                }
            }
        } else {
            //Camera photo
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                delegate?.photoSelected(photo: pickedImage)
            }
        }
    }
}
