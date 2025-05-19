//
//  TrackerFormColorsCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerFormColorsCell: TrackerFormCollectionCell<UIColor> {
    
    static let reuseIdentifier = "TrackerFormColorsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(ColorHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ColorHeaderView.reuseIdentifier)
        items = [
            .color1, .color2, .color3, .color4, .color5, .color6,
            .color7, .color8, .color9, .color10, .color11, .color12,
            .color13, .color14, .color15, .color16, .color17, .color18
        ]
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor?) {
        guard let color else { return }
        if let index = items.firstIndex(where: { $0.isEqual(to: color) }) {
            selectedIndexPath = IndexPath(item: index, section: 0)
        } else {
            selectedIndexPath = nil
        }
        
        collectionView.reloadData()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCell.reuseIdentifier,
            for: indexPath
        ) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: items[indexPath.item], isSelected: selectedIndexPath == indexPath)
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ColorHeaderView.reuseIdentifier,
                for: indexPath
              ) as? ColorHeaderView else {
            return UICollectionReusableView()
        }

        return header
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ColorCell {
            previousCell.configure(with: items[previousIndexPath.item], isSelected: false)
        }
        
        selectedIndexPath = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            cell.configure(with: items[indexPath.item], isSelected: true)
        }
        
        onItemSelected?(items[indexPath.item])
    }
    
}
