//
//  ColorSelector_Drag.swift
//  MyPoster
//
//  Created by 宋小伟 on 2022/10/13.
//

import UIKit

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
       
        let color = colors[indexPath.row]
        let provider = NSItemProvider(object: color)
        let item = UIDragItem(itemProvider: provider)
        
        return [item]
    }
    
    
}
