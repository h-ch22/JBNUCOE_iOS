//
//  PhotoPicker.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI
import PhotosUI
import MobileCoreServices

struct PhotoPicker: UIViewControllerRepresentable {
    @ObservedObject var mediaItems : PickedMediaItems
    
    typealias UIViewControllerType = PHPickerViewController
    var didFinishPick: (_ didSelectedItems : Bool) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        if !mediaItems.items.isEmpty{
            mediaItems.items.removeAll()
        }
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    class Coordinator : PHPickerViewControllerDelegate{
        var photoPicker : PhotoPicker
        
        init(with photoPicker : PhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else{ return }
            photoPicker.didFinishPick(!results.isEmpty)
            
            for result in results{
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first, let utType = UTType(typeIdentifier) else{continue}
                
                self.getPhoto(from: itemProvider, typeIdentifier: typeIdentifier)
            }
        }
        
        
        
        private func getPhoto(from itemProvider : NSItemProvider, typeIdentifier : String){
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier){url, error in
                if let error = error{
                    print(error)
                }
                
                guard let url = url else{return}
                
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentDirectory?.appendingPathComponent(url.lastPathComponent) else{return}
                
                do{
                    if FileManager.default.fileExists(atPath: targetURL.path){
                        try FileManager.default.removeItem(at: targetURL)
                    }
                    
                    try FileManager.default.copyItem(at: url, to: targetURL)
                    
                    DispatchQueue.main.async{
                        self.photoPicker.mediaItems.append(item:PhotoPickerModel(with: targetURL))
                    }
                }  catch{print(error)}
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
}
