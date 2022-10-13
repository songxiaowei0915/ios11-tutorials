//
//  FontStyle_Drag.swift
//  MyPoster
//
//  Created by 宋小伟 on 2022/10/13.
//

import UIKit
import MobileCoreServices

extension FontStylesTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let string = fontNames[indexPath.row]
        
        guard let data = string.data(using: .utf8) else {
            return []
        }
        
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    
}
