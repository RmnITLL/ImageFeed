//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 04.04.2025.
//

import UIKit
import ProgressHUD
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - Properties
    var image: WebImage? {
        didSet {
            guard isViewLoaded, let image = image else { return }
            updateImage(from: image.largeImageURL)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 3.0
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "share_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "nav_back_button_white"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorAlert = AlertPresenter(viewController: self)

   // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollView()
        setImageView()
        setBackButton()
        setShareButton()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImage))
        
        doubleTapGesture.numberOfTapsRequired = 2
        
        imageView.addGestureRecognizer(doubleTapGesture)
        imageView.isUserInteractionEnabled = true
        
        guard let image = image else { return }
        
        updateImage(from: image.largeImageURL)
    }

    // MARK: - Methods
    private func setImageView() {
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setShareButton() {
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
        shareButton.widthAnchor.constraint(equalToConstant: 50),
        shareButton.heightAnchor.constraint(equalToConstant: 50),
        shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11)
        ])
    }

    private func centerImageIfNeeded() {
        let newContentSize = scrollView.contentSize
        let visibleRectSize = scrollView.bounds.size
        let x = max((visibleRectSize.width - newContentSize.width) / 2, 0)
        let y = max((visibleRectSize.height - newContentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(hScale, vScale)
        if scale > 0 {
            scrollView.setZoomScale(scale, animated: false)
        }
        scrollView.layoutIfNeeded()
        centerImageIfNeeded()
    }
    
    private func updateImage(from url: URL) {
        UIBlockingProgressHUD.show()
        
        let placeholderImage = UIImage(named: "placeholder")
        imageView.contentMode = .center
        
        imageView.kf.setImage(with: url, placeholder: placeholderImage) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                let alertModel = AlertModel(title: "Ошибка",
                                            message: "Не удалось загрузить изображение",
                                            buttonText: "Ok",
                                            completion: { self.navigationController?.popViewController(animated: true)},
                                            secondButtonText: nil,
                                            secondButtonCompletion: nil)
                
                errorAlert.showAlert(with: alertModel)
                print("ERROR: Image upload error: \(error)")
            }
        }
    }

    @objc
    private func didDoubleTapImage() {
        scrollView.setZoomScale(1.0, animated: true)
        centerImageIfNeeded()
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(share, animated: true)
    }
}

// MARK: - Extensios
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageIfNeeded()
    }

    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        centerImageIfNeeded()
    }
}

extension SingleImageViewController: UIGestureRecognizerDelegate {
    private func gustureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
