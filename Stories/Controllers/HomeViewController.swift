//
//  HomeViewController.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import UIKit

enum Section {
    case videos
    case feed
}

enum Item {
    case videos(Video)
    case feed(FeedItem)
}

struct HomeSection {
    let type: Section
    let cell: [Item]
}

final class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView?

    private let viewModel = ViewModel(remoteLoader: RemoteUsersLoader())
    
    private var sections = [HomeSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "Instagram"))
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        Task {
            await viewModel.getVideos()
            await configureModels()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UsersCell.self, forCellWithReuseIdentifier: UsersCell.identifier)
        collectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: FeedImageCell.identifier)
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    private func configureModels() async {
        sections.append(
            HomeSection(type: .videos, cell: viewModel.videos.map({ Item.videos($0) }))
        )
        
        sections.append(
            HomeSection(type: .feed, cell: FeedItem.demoFeed.map({ Item.feed($0) }))
        )
        
        collectionView?.reloadData()
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
            
        case .videos:
            return createUsersSection()
        case .feed:
            return createFeed()
        }
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100)), subitem: item, count: 4)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    private func createFeed() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let _: UsersCell = collectionView.cellForItem(at: indexPath) as? UsersCell {
            let video = viewModel.videos[indexPath.row]
            let vc = VideoViewController(video: video)
            self.present(vc, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = sections[indexPath.section].cell[indexPath.row]

        switch model {
            
        case .videos(let videos):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersCell.identifier, for: indexPath) as! UsersCell
            cell.configure(with: videos)
            return cell
            
        case .feed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as! FeedImageCell
            return cell
            
        }
    }
}
