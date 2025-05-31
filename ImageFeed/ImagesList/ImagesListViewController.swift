//
//  ViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 23.03.2025.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesViewControllerProtocol {
    // MARK: - Private properties
    private var presenter: ImagePresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isOpaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.isEditing = false
        tableView.allowsSelection = true
        tableView.backgroundColor = .ypBlack
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.contentMode = .scaleToFill
        setTableView()
        
        presenter = ImagesListPresenter(imagesListService: ServiceListImages.shared)
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    // MARK: - Override Properie
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Private Methods
    private func setTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        DispatchQueue.main.async {
            if oldCount != newCount {
                self.tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
    
    func updateCellLikeStatus(for photoId: String) {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPaths {
            guard
                indexPath.row < presenter.images.count,
                presenter.images[indexPath.row].id == photoId,
                let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell
            else { continue }
            
            let isLiked = presenter.images[indexPath.row].isLiked
            cell.setIsLiked(isLiked)
        }
    }
    
    func showErrorAlert(with title: String, message: String) {
        let alertModel = AlertModel(
            title: title,
            message: message,
            buttonText: "OK",
            completion: nil,
            secondButtonText: nil,
            secondButtonCompletion: nil
        )
        AlertPresenter(viewController: self).showAlert(with: alertModel)
    }
}

// MARK: - Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        presenter.configCell(for: cell, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if ProcessInfo.processInfo.arguments.contains("UITEST") {
//            return
//        }
        
        if indexPath.row == presenter.images.count - 1 {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let photo = presenter.images[indexPath.row]
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.image = photo
        singleImageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.calculateHeightForRow(at: indexPath, tableViewWidth: tableView.bounds.width)
    }
}

extension ImagesListViewController: CellLikeImageDelegate {
    func cellImageLikeDidTaped(_ cell: ImagesListCell) {
        assert(Thread.isMainThread)
        print("The like button is pressed in the cell \(cell)")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = presenter.images[indexPath.row]
        presenter.changeLike(photoId: photo.id, isLike: !photo.isLiked)
    }
}
