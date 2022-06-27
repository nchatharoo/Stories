//
//  FilesViewController.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation
import UIKit
import AVFoundation

protocol FileViewControllerDelegate: AnyObject {
    func didLongPress(_ vc: FileViewController, sender: UILongPressGestureRecognizer)
    func didTap(_ vc: FileViewController, sender: UITapGestureRecognizer)
    func videoEnded(_ vc: FileViewController)
}

final class FileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let file: VideoFile
    
    weak var postDelegate: FileViewControllerDelegate?
    
    private let progress: CMTime = CMTimeMake(value: 4, timescale: 1)
    
    private var timer: Timer?

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    public let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    var player: AVPlayer?

    public let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .systemBackground
        return label
    }()
    
    public let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .white
        progressView.progressViewStyle = .default
        return progressView
    }()
    
    
    //MARK: Gesture
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tg.numberOfTapsRequired = 1
        tg.delegate = self
        return tg
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    
    //MARK: Init
        
    init(file: VideoFile) {
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        view.addGestureRecognizer(longPressGesture)
        view.addGestureRecognizer(tapGesture)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        configurePlayer(with: file.link)
        configureTimer()
            
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storyDidEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(playerView)
        view.addSubview(closeButton)
        view.addSubview(usernameLabel)
        view.addSubview(progressView)
        view.addSubview(avatarImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameLabel.sizeToFit()
        
        avatarImageView.frame = CGRect(x: 10,
                                       y: 30,
                                       width: 50,
                                       height: 50)
        
        usernameLabel.frame = CGRect(x: avatarImageView.right+10,
                                     y: avatarImageView.top+15,
                                     width: usernameLabel.width,
                                     height: usernameLabel.height)
        
        closeButton.frame = CGRect(x: view.width - 45,
                                   y: 30,
                                   width: 25,
                                   height: 25)
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.height)
        
        playerView.frame = view.bounds
                
        progressView.frame = CGRect(x: 10,
                                    y: 10,
                                    width: view.width - closeButton.width,
                                    height: 10)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    private func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if let duration = self.player?.currentItem?.duration.seconds,
               let currentMoment = self.player?.currentItem?.currentTime().seconds {
                self.setProgressView(currentMoment, and: duration)
            }
        })
    }
        
    private func setProgressView(_ currentMoment: Double, and duration: Double) {
        progressView.progress = Float(currentMoment / duration)
    }
    
    private func configurePlayer(with video: String) {
        self.player = AVPlayer(url: URL(string: video)!)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(playerLayer)
        playerLayer.player = player
        player?.play()
    }
    
    //MARK: Actions
    
    @objc private func storyDidEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            postDelegate?.videoEnded(self)
        }
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        postDelegate?.didLongPress(self, sender: sender)
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        postDelegate?.didTap(self, sender: sender)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}
