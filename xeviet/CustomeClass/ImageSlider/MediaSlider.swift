//
//  ImageSlider.swift
//  Stamp
//
//  Created by nhatquangz on 4/10/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import RxGesture

protocol MediaSliderItem {
    var imageURL: URL? { get }
}

class MediaSlider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    /**
    Resouse type: from url or from local
    **/
    enum ResourceType {
        case url
        case local
    }
    
    enum IndicatorType {
        case none // Hidden
        case inside // Inside image
        case outside // Outside image
    }
    
    /**
    Variable
    **/
    var stackView: UIStackView?
    var scrollView = BaseScrollView()
    let mediaStack = UIStackView()
    let indicator = UIPageControl()
    var indicatorType: IndicatorType = .outside {
        didSet {
            changeIndicatorPosition()
        }
    }
    let currentPage = BehaviorRelay<Int>(value: 0) //Variable<Int>(0)
    let disposedBag = DisposeBag()
    
    private var timerBag : DisposeBag?
    
    // Action that is injected to process along side with preview-image action
    var actionInjected: ((MediaSliderItem) -> Void)?
    var itemSelected: ((String) -> Void)?
    
    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.stackView = stackView
        
        let imageContainer = CardView()
        imageContainer.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        stackView.addArrangedSubview(imageContainer)
        stackView.addArrangedSubview(indicator)
        
        mediaStack.axis = .horizontal
        scrollView.layout(contentView: mediaStack, axis: .horizontal)
        
        indicator.currentPageIndicatorTintColor = UIColor(hex: 0x2f3840)
        indicator.pageIndicatorTintColor = UIColor(hex: 0xefefef)
        indicator.isUserInteractionEnabled = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.backgroundColor = .clear
        scrollView.delaysContentTouches = false
        
        imageContainer.cornerRadius = 5
        
        indicator.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
        scrollView.rx.contentOffset.asObservable()
            .map { [weak self] offset -> Int in
                guard let self = self else { return 0 }
                let width = self.scrollView.frame.width
                if width == 0 { return 0 }
                return Int( Darwin.round (offset.x / width))
            }
            .bind(to: currentPage)
            .disposed(by: disposedBag)
        
        currentPage.asDriver()
            .drive(indicator.rx.currentPage)
            .disposed(by: disposedBag)
    }
    
    /**
     Change position of indicator
     **/
    func changeIndicatorPosition() {
        switch indicatorType {
        case .none:
            self.indicator.isHidden = true
            
        case .inside:
            self.addSubview(indicator)
            indicator.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
        case .outside:
            self.stackView?.addArrangedSubview(indicator)
        }
    }
    
}


// MARK: - Config
/**
There are two types of item: image and video
Config source from URL or MediaModel
**/
extension MediaSlider {
    // Sources from urls or local image
    func config(data: [String], sourceType: ResourceType = .url) {
        // Remove old slider before add new
        mediaStack.arrangedSubviews.forEach { (iv) in
            iv.removeFromSuperview()
        }
        
        // Add new slider
        //guard data.count > 0 else { return }
        var views: [UIView] = []
        
        if sourceType == .url {
            views = getView(fromURLs: data)
        } else {
            views = getView(fromLocal: data)
        }
        views.forEach {
            mediaStack.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
            }
        }
        
        /// Config indicator
        indicator.numberOfPages = views.count
        self.indicator.isHidden = (views.count <= 1 || indicatorType == .none)
    }
    
    // Sources from urls or local image
    func config(items: [MediaSliderItem]) {
        // Stop timer
        timerBag = nil
        
        // Remove old slider before add new
        mediaStack.arrangedSubviews.forEach { (iv) in
            iv.removeFromSuperview()
        }
        
        // Add new slider
        var views: [UIView] = []
        views = getView(items: items)

        views.forEach {
            mediaStack.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
            }
        }
        
        /// Config indicator
        self.indicator.numberOfPages = views.count
        self.indicator.currentPage = 0
        self.indicator.isHidden = (views.count <= 1 || indicatorType == .none)
        self.scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}



// MARK: - Helper
/**
Functions that help to creates item view
**/
extension MediaSlider {
    /**
    Create item
    **/
    private func getView(fromURLs urls: [String]) -> [UIView] {
        let imageURLs = urls.compactMap { $0.urlEncoded }
        let listViews = imageURLs.map { url -> UIView in
            let imageView = UIImageView() // EEZoomableImageView()
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.indicatorType = .activity
            let processor = DownsamplingImageProcessor(size: CGSize(width: 1024, height: 1024))
            if !url.absoluteString.hasSuffix("gif") {
                //imageView.kf.setImage(with: url, options: [.processor(processor)])
                
                imageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)], progressBlock: nil, completionHandler: { result in
                    switch result {
                    case .success(_):
                        break
                        
                    case .failure(_):
                        imageView.image = UIImage(named: "no-img")
                        break
                    }
                })
                
                
            } else {
                // Dont apply DownsamplingImageProcessor to gif image
                //imageView.kf.setImage(with: url, options: [])
                
                imageView.kf.setImage(with: url, placeholder: nil, options: [], progressBlock: nil, completionHandler: { result in
                    switch result {
                    case .success(_):
                        break
                        
                    case .failure(_):
                        imageView.image = nil //UIImage(named: "no-img")
                        break
                    }
                })
            }
            return imageView
        }
        return listViews
    }
    
    private func getView(fromLocal imageNames: [String]) -> [UIView] {
        let listViews = imageNames.map { imageName -> UIImageView in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: imageName)
            
            // Callback action when user tap on image
            imageView.rx.tapGesture().when(.recognized).asObservable()
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.itemSelected?(imageName)
                })
                .disposed(by: self.disposedBag)
            
            return imageView
        }
        return listViews
    }
    
    private func getView(items: [MediaSliderItem]) -> [UIView] {

        let listViews = items.map { [weak self] item -> UIView in
            guard let self = self else { return UIView() }
            
            let imageView = UIImageView() // EEZoomableImageView()
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.indicatorType = .activity
            
            var opts: KingfisherOptionsInfo? = nil
            if let path = item.imageURL?.absoluteString, !path.hasSuffix("gif") {
                let scale: CGFloat = UIScreen.main.scale
                let processor = DownsamplingImageProcessor(size: CGSize(width: self.bounds.width * scale, height: self.bounds.height * scale))
                opts = [.processor(processor)]
            }
            
            imageView.kf.setImage(with: item.imageURL, placeholder: nil, options: opts, progressBlock: nil, completionHandler: { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    imageView.image = UIImage(named: "no-img")
                    break
                }
            })
            
            // Callback action when user tap on image
            imageView.rx.tapGesture().when(.recognized).asObservable()
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.actionInjected?(item)
                })
                .disposed(by: self.disposedBag)
            
            return imageView
        }
        return listViews
    }
    
    /**
    Handle navigation action in item
    **/
    private func handleNavigationTarget(for view: UIView, target: String) {
        view.rx.tapGesture().when(.recognized).asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if target.trimSpace() != "" {
                   // AppCoordinator.shared.handle(target: target)
                }
            })
            .disposed(by: disposedBag)
    }
    
    
}


// MARK: - Control
extension MediaSlider {
    /**
    - Auto scroll slider
    - Combine time with pan gesture to avoid conflict between auto and user's action
    **/
    func autoPlay(duration: RxTimeInterval = .seconds(3)) {
        timerBag = DisposeBag()
        guard let timerBag = timerBag else { return }
        
        let swipeGestureObserver = scrollView.rx.anyGesture(.pan(), .swipe(direction: .left), .swipe(direction: .right), .pinch()).asObservable()
        let timerObserver = Observable<Int>.interval(duration, scheduler: MainScheduler.instance).skip(1)
        Observable<Int?>.combineLatest(swipeGestureObserver, timerObserver) { [weak self] (gesture, timerCount) in
            guard let self = self else { return nil }
            guard gesture.state == .possible else { return nil }
            let nextPage = self.indicator.currentPage + 1
            return nextPage >= self.indicator.numberOfPages ? 0 : nextPage
        }
        .unwrap()
        .subscribe(onNext: { [weak self] nextPage in
            guard let self = self else { return }
            let targetPoint = CGPoint(x: CGFloat(nextPage) * self.scrollView.frame.width, y: 0)
            self.scrollView.setContentOffset(targetPoint, animated: true)
        })
            .disposed(by: timerBag)
    }
    
    func gotoNextPage() {
        var page = self.indicator.currentPage + 1
        if page >= self.indicator.numberOfPages {
            page = 0
        }
        
        let targetPoint = CGPoint(x: CGFloat(page) * self.scrollView.frame.width, y: 0)
        self.scrollView.setContentOffset(targetPoint, animated: true)
    }
    
    func gotoPreviousPage() {
        let page = max(0, self.indicator.numberOfPages - 1)
        
        let targetPoint = CGPoint(x: CGFloat(page) * self.scrollView.frame.width, y: 0)
        self.scrollView.setContentOffset(targetPoint, animated: true)
    }
}
