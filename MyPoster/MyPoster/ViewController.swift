//
//  ViewController.swift
//  MyPoster
//
//  Created by 宋小伟 on 2022/10/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorSelector: UICollectionView!
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var previewCollection: UICollectionView!
    
    var titleText = "Click here to set your title"
    var titleFontName = "Helvetica Neue"
    var titleColor = UIColor.white
    var posterBg: UIImage!
    
    func drawPoster() {
        let drawRect = CGRect(x: 0, y: 0, width: 1600, height: 1200)
        let titleRect = CGRect(x: 200, y: 200, width: 1200, height: 200)
        let titleFont = UIFont(name: titleFontName, size: 90) ?? UIFont.systemFont(ofSize: 90)
        
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: titleFont,
            .paragraphStyle: centered
        ]
        
        let render = UIGraphicsImageRenderer(size: drawRect.size)
        
        poster.image = render.image(actions: {
            UIColor.gray.set()
            $0.fill(drawRect)
            posterBg?.draw(at: CGPoint(x: 0, y: 0))
            
            titleText.draw(in: titleRect, withAttributes: titleAttributes)
        })
    }
    
    var colors = [UIColor]()
    func generateWebSafeColors() {
        let colorIndex: [CGFloat] = [0, 51/255, 102/255, 153/255, 204/255, 1]
        
        for i in colorIndex {
            for j in colorIndex {
                for k in colorIndex {
                    colors.append(UIColor(red: i, green: j, blue: k, alpha: 1))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        generateWebSafeColors()
        colorSelector.dataSource = self
        
        drawPoster()
        
        colorSelector.dragDelegate = self
        
        poster.isUserInteractionEnabled = true
        poster.addInteraction(UIDropInteraction(delegate: self))
        poster.addInteraction(UIDragInteraction(delegate: self))
        
        previewCollection.dropDelegate = self
    }
    
    var posterPreviews = [UIImage]()
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorSelector {
            return colors.count
        }else{
            if posterPreviews.isEmpty {
                let previewFrame = CGRect(
                    x: 0, y: 0,
                    width: collectionView.bounds.size.width,
                    height: collectionView.bounds.size.height)
                let promptLabel = UILabel(frame: previewFrame)
                
                promptLabel.text = "Drag your poster here"
                promptLabel.textColor = UIColor.gray
                promptLabel.textAlignment = .center
                
                collectionView.backgroundView  = promptLabel
                
                return 0
            }else{
                return posterPreviews.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorSelector {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
            
            cell.backgroundColor = colors[indexPath.row]
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 6
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCell", for: indexPath) as! PreviewCell
            cell.preview.image = posterPreviews[indexPath.row]
            
            return cell
        }
    }
    
    
}

