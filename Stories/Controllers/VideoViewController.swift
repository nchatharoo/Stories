//
//  VideoFileViewController.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import UIKit

class VideoViewController: UIViewController {
    let video: Video
    
    let pagingController: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: [:])
    
    init(video: Video) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagingController()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configurePagingController() {
        guard let file = video.videoFiles.first else { return }
        
        let vc = configureFileViewController(with: file)

        pagingController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)

        pagingController.dataSource = self
        
        view.addSubview(pagingController.view)
        pagingController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        addChild(pagingController)
        pagingController.didMove(toParent: self)
    }
}

extension VideoViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = (viewController as? FileViewController)?.file else { return nil }

        guard let index = video.videoFiles.firstIndex(where: {
            $0.id == viewController.id
        }) else { return nil }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let file = video.videoFiles[priorIndex]
        
        return configureFileViewController(with: file)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = (viewController as? FileViewController)?.file else { return nil }

        guard let index = video.videoFiles.firstIndex(where: {
            $0.id == viewController.id
        }) else { return nil }
        
        guard index < video.videoFiles.count - 1 else {
            return nil
        }
        
        let nextIndex = index + 1
        let file = video.videoFiles[nextIndex]
        
        return configureFileViewController(with: file)
    }
    
    private func configureFileViewController(with file: VideoFile) -> UIViewController {
        let vc = FileViewController(file: file)
        vc.usernameLabel.text = video.user.name
        vc.avatarImageView.downloadImageFrom(link: URL(string: video.image)!)
        vc.postDelegate = self
        return vc
    }
}

extension VideoViewController: FileViewControllerDelegate {
    
    func didLongPress(_ vc: FileViewController, sender: UILongPressGestureRecognizer) {
        if sender.state == .began ||  sender.state == .ended {
            if(sender.state == .began) {
                vc.player?.pause()
            } else {
                vc.player?.play()
            }
        }
    }
    
    func didTap(_ vc: FileViewController, sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: view)
        
        if touchLocation.x < view.center.x {
            guard let previousVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerBefore: vc) else {
                vc.player?.seek(to: .zero)
                return
            }
            pagingController.setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
        } else {
            guard let nextVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerAfter: vc) else {
                dismiss(animated: true)
                return
            }
            pagingController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func videoEnded(_ vc: FileViewController) {
        guard let nextVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerAfter: vc) else {
            dismiss(animated: true)
            return
        }
        pagingController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
}
