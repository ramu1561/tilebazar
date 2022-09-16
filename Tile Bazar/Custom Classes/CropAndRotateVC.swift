//
//  CropAndRotateVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/24/22.
//

import UIKit

class CropAndRotateVC: ParentVC,CropViewControllerDelegate, UIImagePickerControllerDelegate {
    
    private let imageView = UIImageView()
    var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.circular
    private var croppedRect = CGRect.zero
    @IBOutlet weak var lblChangePhoto: UILabel!
    @IBOutlet weak var btnBackIcon: UIButton!
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblChangePhoto.text = NSLocalizedString("Change Photo", comment: "")
        setupCropViewControllerToDefault()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool){
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func toggleBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        EditProfileVC.sharedInstance?.imgUserIcon.image = image
        self.navigationController?.popViewController(animated: true)
        cropViewController.dismiss(animated: false, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        self.imageView.isHidden = false
        cropViewController.dismiss(animated: true, completion: nil)
    }
    @objc public func didTapImageView() {
        // When tapping the image view, restore the image to the previous cropping state
        setupCropViewControllerToDefault()
    }
    func setupCropViewControllerToDefault(){
        let cropController = CropViewController(croppingStyle: croppingStyle, image: self.image!)
        cropController.delegate = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
        cropController.presentAnimatedFrom(self,
                                           fromImage: self.imageView.image,
                                           fromView: nil,
                                           fromFrame: viewFrame,
                                           angle: self.croppedAngle,
                                           toImageFrame: self.croppedRect,
                                           setup: { self.imageView.isHidden = true },
                                           completion: nil)
        
        
        
        var newSafeArea = UIEdgeInsets()
        newSafeArea.bottom = 25
        cropController.additionalSafeAreaInsets = newSafeArea
        
        cropController.cropView.translucencyAlwaysHidden = false
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetCustom; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = false // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetButtonHidden = false
        cropController.aspectRatioPickerButtonHidden = true
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        cropController.rotateButtonsHidden = false
        cropController.rotateClockwiseButtonHidden = false
        cropController.aspectRatioPreset = .presetSquare
        cropController.doneButtonTitle = NSLocalizedString("Choose", comment: "")
        cropController.cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutImageView()
    }
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        let padding: CGFloat = 20.0
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
}

