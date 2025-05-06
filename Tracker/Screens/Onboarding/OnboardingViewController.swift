//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 06.05.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let pageControlBottomInset: CGFloat = -137
    }
    
    // MARK: - Views
    
    private lazy var pageControl: UIPageControl = {
        $0.currentPage = 0
        $0.numberOfPages = pagesData.count
        $0.currentPageIndicatorTintColor = .ypBlack
        $0.pageIndicatorTintColor = .ypGray
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIPageControl())
    
    // MARK: - Internal Properties
    
    var onCompletion: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let pagesData: [OnboardingPageData] = [
        OnboardingPageData(title: "Отслеживайте только то, что хотите", imageResource: .blueOnboarding),
        OnboardingPageData(title: "Даже если это не литры воды и йога", imageResource: .redOnboarding)
    ]
    
    private lazy var pages: [UIViewController] = {
        pagesData.map { pageData in
            let stepController = OnboardingStepViewController(pageData: pageData)
            stepController.onButtonTapped = { [weak self] in
                self?.onCompletion?()
            }
            return stepController
        }
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

}

// MARK: - Private Methods

private extension OnboardingViewController {
    
    func setupViewController() {
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.pageControlBottomInset)
        ])
    }
    
}

// MARK: - Actions

@objc
private extension OnboardingViewController {
    
    func pageControlTapped() {
        let targetPage = pageControl.currentPage
        guard let currentController = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentController),
              targetPage != currentIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = targetPage > currentIndex ? .forward : .reverse
        setViewControllers([pages[targetPage]], direction: direction, animated: true, completion: nil)
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        
        return previousIndex >= 0 ? pages[previousIndex] : pages[pages.count - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        
        return nextIndex < pages.count ? pages[nextIndex] : pages[0]
    }
    
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentController = viewControllers?.first,
              let index = pages.firstIndex(of: currentController)
        else { return }
        
        pageControl.currentPage = index
    }
    
}
