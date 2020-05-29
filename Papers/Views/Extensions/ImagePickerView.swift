//
//  ImagePickerView.swift
//  Papers
//
//  Created by Sascha Sallès on 24/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isVisible: Bool
    @Binding var image: UIImage?
    var sourceType: Int
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.allowsEditing = true
        viewController.sourceType = sourceType == 1 ? .photoLibrary : .camera
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //TODO
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isVisible: $isVisible, image: $image)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isVisible: Bool
        @Binding var image: UIImage?
        init(isVisible: Binding<Bool>, image: Binding<UIImage?>){
            _isVisible = isVisible
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiimage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            image = uiimage
            isVisible = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isVisible = false
        }
        
    }
}
