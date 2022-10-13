//
//  ViewController.swift
//  WhatIsThat
//
//  Created by 宋小伟 on 2022/10/12.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var photoSelected: UIImageView!
    
    @IBOutlet weak var probability: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func grabAPicture(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
            _ in
            self.takePhoto(from: .camera)
        })
        let libraryAction = UIAlertAction(title: "Choose from Photos", style: .default, handler: {
            _ in
            self.takePhoto(from: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
        
    }
    
}

extension ViewController {
    enum PhotoSource {
        case camera, photoLibrary
    }
    
    func takePhoto(from source: PhotoSource) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = source == .camera ? .camera : .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func resize(image: UIImage, to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension ViewController {
    func guess(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Cannot create a core image object")
        }
        
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
            fatalError("Cannot loaed CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) {
            (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation], let first = results.first else {
                fatalError("Cannot fetch results from VNCoreMLRequest")
            }
            
            DispatchQueue.main.async {
                self.descriptionLabel.text = first.identifier
                self.probability.text = "\(first.confidence * 100) %"
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async {
            try? handler.perform([request])
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoSelected.image = image
            
            if let newImage = resize(image: image, to: CGSize(width: 224, height: 224)) {
                guess(image: newImage)
            }
            
        }
    }
}

