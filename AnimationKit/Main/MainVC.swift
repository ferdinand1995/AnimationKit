//
//  ViewController.swift
//  AnimationKit
//
//  Created by Ferdinand on 20/12/21.
//

import UIKit

enum MainCellType {
    case carousel, vertical
}

class MainVC: UICollectionViewController {

    var data = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(cellWithClass: MenuCell.self)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        data.append((type: MainCellType.vertical, data: "Animate TableView"))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let verticalCell = data[indexPath.item] as? (type: MainCellType, data: String), verticalCell.type == .vertical {
            let cell = collectionView.dequeueReusableCell(withClass: MenuCell.self, for: indexPath)
            cell.titleLabel.text = verticalCell.data
            cell.layoutIfNeeded()
            cell.backgroundCardView.dropShadowCell()
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let verticalCell = data[indexPath.item] as? (type: MainCellType, data: String), verticalCell.type == .vertical {
            self.navigationController?.pushViewController(AnimatedTableVC(), animated: true)
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
