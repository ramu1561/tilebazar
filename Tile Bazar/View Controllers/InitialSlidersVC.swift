//
//  InitialSlidersVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/30/22.
//

import UIKit

class InitialSlidersVC: ParentVC {

    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnRightArrow: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var arrSliders = ["img_screen1","img_screen2","img_screen3","img_screen4"]
    var arrBgColors = ["#fdf7df","#e7e7e7","#e6f3ea","#e5f088"]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = arrSliders.count
        btnSkip.isHidden = false
        btnDone.isHidden = true
        btnRightArrow.isHidden = false
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let isSlidersViewed = UserDefaults.standard.bool(forKey: "isSlidersViewed")
        if isSlidersViewed{
            self.makeRootViewController()
        }
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //skip
            //show login screen
            makeSlidersViewed()
        }
        else if sender.tag == 1{
            //arrow
            let collectionBounds = self.collectionView.bounds
            let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
        else{
            //done
            //show login screen
            makeSlidersViewed()
        }
    }
    func makeSlidersViewed(){
        UserDefaults.standard.set(true, forKey: "isSlidersViewed")
        self.makeRootViewController()
    }
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
        pageControl.currentPage = Int(contentOffset) / Int(frame.width)
        checkButtons()
    }
    func checkButtons(){
        if pageControl.currentPage == 3{
            btnSkip.isHidden = true
            btnDone.isHidden = false
            btnRightArrow.isHidden = true
        }
        else{
            btnSkip.isHidden = false
            btnDone.isHidden = true
            btnRightArrow.isHidden = false
        }
    }
}
extension InitialSlidersVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSliders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellHomeBanners", for: indexPath) as? CollectionCellHomeBanners else{
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = UIColor.init(hexString: arrBgColors[indexPath.item])
        cell.imgView.image = UIImage(named: arrSliders[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        checkButtons()
    }
}
extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
