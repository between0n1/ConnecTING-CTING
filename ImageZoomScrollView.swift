//
//  ImageZoomScrollView.swift
//  Pods
//
//  Created by sunhyeok on 2021/06/21.
//

import UIKit

class ImageZoomScrollView: UIScrollView, UIScrollViewDelegate {

    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!
    
    convenience init(frame: CGRect, imageView: UIImageView) {
        self.init(frame: frame)

        // Creates the image view and adds it as a subview to the scroll view
        self.imageView = imageView
        self.imageView.frame = frame
        self.imageView.contentMode = .scaleAspectFill
        addSubview(self.imageView)

        setupScrollView()
        setupGestureRecognizer()
    }
    
    func setupScrollView(){
        delegate = self
        minimumZoomScale = 1.0
        maximumZoomScale = 5.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }}
