//
//  WatchlistVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/14/22.
//

import UIKit

class CellWatchlistContainer: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUnderline: UILabel!
}
class WatchlistVC: ParentVC {
    
    @IBOutlet weak var collectionContainer: UICollectionView!
    var indexPathToSelect = IndexPath(item: 0, section: 0)
    static var sharedInstace : WatchlistVC?
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    var arrContainerOptions = ["Products","Sellers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewContainer.delegate = self
        WatchlistVC.sharedInstace = self
        // Do any additional setup after loading the view.
    }
    
}
extension WatchlistVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrContainerOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWatchlistContainer", for: indexPath) as? CellWatchlistContainer else{
            return UICollectionViewCell()
        }
        cell.lblTitle.text = arrContainerOptions[indexPath.row]
        if indexPathToSelect == indexPath{
            cell.lblTitle.textColor = #colorLiteral(red: 0.7529411765, green: 0.1450980392, blue: 0.168627451, alpha: 1)
            cell.lblUnderline.isHidden = false
        }
        else{
            cell.lblTitle.textColor = .black
            cell.lblUnderline.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0
        return CGSize(width: yourWidth, height: 44.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        indexPathToSelect = indexPath
        collectionContainer.reloadData()
        if indexPathToSelect.row == 0{
            scrollViewContainer.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        }
        else{
            scrollViewContainer.setContentOffset(CGPoint(x:self.view.frame.size.width,y: 0), animated: true)
        }
    }
}
extension WatchlistVC : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollViewContainer{
            let currentPage = Int(scrollViewContainer.contentOffset.x / scrollViewContainer.bounds.width)
            if currentPage == 0{
                indexPathToSelect = IndexPath(item: 0, section: 0)
                collectionContainer.reloadData()
                scrollViewContainer.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            }
            else{
                indexPathToSelect = IndexPath(item: 1, section: 0)
                collectionContainer.reloadData()
                scrollViewContainer.setContentOffset(CGPoint(x:self.view.frame.size.width,y: 0), animated: true)
            }
        }
    }
}
