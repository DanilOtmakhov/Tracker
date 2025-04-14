//
//  TrackerFormEmojiCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerFormEmojiCell: TrackerFormCollectionCell<String> {
    
    static let reuseIdentifier = "TrackersFormEmojiCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.register(EmojiCell.self,
                    forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(EmojiHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: EmojiHeaderView.reuseIdentifier)
        
        items = [
            "😊", "😻", "🌺", "🐶", "❤️", "😱",
            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
            "🥦", "🏓", "🥇", "🎸", "🏝️", "😴"
        ]
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCell.reuseIdentifier,
            for: indexPath
        ) as? EmojiCell else {
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
                withReuseIdentifier: EmojiHeaderView.reuseIdentifier,
                for: indexPath
              ) as? EmojiHeaderView else {
            return UICollectionReusableView()
        }

        return header
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? EmojiCell {
            previousCell.configure(with: items[previousIndexPath.item], isSelected: false)
        }
        
        selectedIndexPath = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
            cell.configure(with: items[indexPath.item], isSelected: true)
        }
        
        onItemSelected?(items[indexPath.item])
    }

}
