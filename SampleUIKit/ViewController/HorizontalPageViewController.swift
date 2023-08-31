//
//  HorizontalPageViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/31.
//

import UIKit

final class HorizontalPageViewController: UIViewController {

    @IBOutlet private weak var sampleScrollView: UIScrollView! {
        didSet {
            sampleScrollView.delegate = self
            sampleScrollView.isPagingEnabled = true
            sampleScrollView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet private weak var samplePageControl: UIPageControl! {
        didSet {
            samplePageControl.isUserInteractionEnabled = false
        }
    }

    static func instantiate() -> HorizontalPageViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! HorizontalPageViewController
    }

    private let scrollHeight: CGFloat = 200.0
    private let imageWidth: CGFloat = UIScreen.main.bounds.width
    
    private lazy var images: [UIImage] = {
        [UIImage(resource: .entertainment),
         UIImage(resource: .technology),
         UIImage(resource: .service)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImages()
        setupTimer()
    }

    private func setupImages() {
        sampleScrollView.contentSize = CGSize(
            width: imageWidth * CGFloat(images.count),
            height: scrollHeight
        )
        images.enumerated().forEach { index, image in
            let imageView = UIImageView(
                frame: CGRect(
                    x: imageWidth * CGFloat(index),
                    y: 0,
                    width: imageWidth,
                    height: scrollHeight
                )
            )
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            sampleScrollView.addSubview(imageView)
        }
        samplePageControl.numberOfPages = images.count
    }

    private func setupTimer() {
        let timerProgress = UIPageControlTimerProgress(preferredDuration: 3)
        samplePageControl.progress = timerProgress
        timerProgress.delegate = self
        timerProgress.resumeTimer()
    }
}

// MARK: UIPageControlTimerProgressDelegate
extension HorizontalPageViewController: UIPageControlTimerProgressDelegate {
    func pageControlTimerProgress(_ progress: UIPageControlTimerProgress, shouldAdvanceToPage page: Int) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.sampleScrollView.contentOffset.x += self.imageWidth
        }
        return true
    }
}

// MARK: UIScrollViewDelegate
extension HorizontalPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        samplePageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}
