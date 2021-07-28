//
//  ProfileVC.swift
//  Driver-iOS
//
//  Created by Tran Thanh Nhien on 7/1/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftDate

class ProfileVC: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var avatarImageView: PImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    fileprivate var myBag = DisposeBag()
    fileprivate var viewModel: ProfileVM!
    
    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        setupRxData()
        setupRxAction()
    }
    
    func initComponents() {
        self.title = "DRIVER_INFO".localized()
        
        
        // Register cell
        let cellNib = UINib(nibName: VehicleImageCell.nameOfClass, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: VehicleImageCell.nameOfClass)
        collectionView.rx.setDelegate(self).disposed(by: myBag)
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 20
        collectionViewFlowLayout.minimumInteritemSpacing = 20
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setupRxData() {
        viewModel.driverModel.asDriver()
            .drive(onNext: { [weak self] model in
                guard let self = self,
                    let model = model else { return }

                self.userNameLabel.text = model.userName
                self.ageLabel.text = "Sinh năm: \(model.birthday)"
                self.genderLabel.text = model.sex == "male" ? "Giới tính: Nam" : "Giới tính: Nữ"
                self.carNameLabel.text = model.vehicleKin
                self.licensePlateLabel.text = "Biển số xe: \(model.license)"
                self.colorLabel.text = "Màu: \(model.color)"
                self.viewModel.dataSource.accept(model.imagesUrl)
                //avatar
                if let url = model.avatarUrl.urlEncoded {
                    self.avatarImageView.kf.setImage(with: url)
                }
            })
        .disposed(by: myBag)

        // Bind source for collection view
        viewModel.dataSource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: VehicleImageCell.nameOfClass, cellType: VehicleImageCell.self)) { index, viewModel, cell in
                cell.setup(imageUrl: self.viewModel.dataSource.value[index])
        }
        .disposed(by: myBag)
    }
    
    func setupRxAction() {
        
    }
    
    func setupCollectionView() {
        
    }
    
    
    
}


extension ProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 50
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}
