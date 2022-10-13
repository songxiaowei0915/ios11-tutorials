//
//  PreviewCollection_Drop.swift
//  MyPoster
//
//  Created by 宋小伟 on 2022/10/13.
//

import UIKit

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        if collectionView == previewCollection {
            coordinator.session.loadObjects(ofClass: UIImage.self, completion: {
                guard let draggedImage = $0.first as? UIImage else {
                    return
                }
                
                self.posterPreviews.append(draggedImage)
                self.previewCollection.reloadData()
            })
        }
    }
    
    
}
