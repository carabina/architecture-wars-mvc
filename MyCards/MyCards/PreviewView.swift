//
//  PreviewView.swift
//  MyCards
//
//  Created by Maciej Piotrowski on 23/11/16.
//

import UIKit
import AVFoundation

class PreviewView: UIView {

    let captureButton = PhotoCameraButton(frame: .zero)
    let closeButton = CloseButton(frame: .zero)
    let outline: UIView = UIView(frame: .zero).with { view in
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
    }
    var controlsAlpha: CGFloat = 1.0 {
        didSet {
            captureButton.alpha = controlsAlpha
            closeButton.alpha = controlsAlpha
            outline.alpha = controlsAlpha
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        addSubview(outline)
        addSubview(captureButton)
        addSubview(closeButton)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        //swiftlint:disable force_cast
        return layer as! AVCaptureVideoPreviewLayer
        //swiftlint:enable force_cast
    }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    fileprivate func configureConstraints() {

        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let views: [String: Any] = [
            "photoButton": captureButton,
            "closeButton": closeButton,
            "outline": outline,
            ]

        let metrics: [String: CGFloat]  = [
            "photoButtonHeight": 80,
            "photoButtonWidth": 60,
            "padding": 20,
            "closeButtonHeight": 40,
            "closeButtonWidth": 40,
            "outlinePadX": .cardOffsetX,
            "outlinePadY": .cardOffsetY,
            ]

        let visual = [
            "V:[photoButton(photoButtonWidth)]-(padding)-|",
            "H:[photoButton(photoButtonHeight)]",
            "V:|-(padding)-[closeButton(closeButtonHeight)]",
            "H:[closeButton(closeButtonWidth)]-(padding)-|",
            "H:|-(outlinePadY)-[outline]-(outlinePadY)-|",
            ]

        var constraints: [NSLayoutConstraint] = NSLayoutConstraint.centeredInSuperview(outline)
        constraints.append(NSLayoutConstraint.centeredInSuperview(captureButton, with: .centerX))
        constraints.append(NSLayoutConstraint.height2WidthCardRatio(for: outline))
        visual.forEach {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: $0, options:
                [], metrics: metrics, views: views)
        }

        NSLayoutConstraint.activate(constraints)
    }
}
