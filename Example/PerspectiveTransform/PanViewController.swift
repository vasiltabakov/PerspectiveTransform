//
//  ViewController.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 02/18/2016.
//  Copyright (c) 2016 Paul Zabelin. All rights reserved.
//

import UIKit
import QuartzCore

import PerspectiveTransform

extension UIPanGestureRecognizer {
    func panView() {
        let controlPoint = view!
        let pan = translation(in: controlPoint.superview)
        let transform = CGAffineTransform(translationX: pan.x, y: pan.y)
        controlPoint.center = controlPoint.center.applying(transform)
        setTranslation(CGPoint.zero, in: controlPoint.superview)
    }
}

class PanViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var cornerViews: [UIView]!
    @IBOutlet weak var toBeTransformedView: UIView!

    // MARK: - UIViewController

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePosition()
    }

    // MARK: - Actions

    @IBAction func didPan(_ recognizer: UIPanGestureRecognizer) {
        recognizer.panView()
        updatePosition()
    }

    // MARK: - private
    private func updatePosition() {
        toBeTransformedView.layer.transform = transformToCorners()
    }

    private func transformToCorners() -> CATransform3D {
        return start.projectiveTransform(destination: destination)
    }

    private lazy var start: Perspective = createStartingPerspective()

    private func createStartingPerspective() -> Perspective {
        toBeTransformedView.resetAnchorPoint()
        return Perspective(toBeTransformedView.frame)
    }

    private var destination: Perspective {
        return .init(cornerViews.sorted {$0.tag < $1.tag}.map {$0.center})
    }
}
