/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Generic text cell
*/

import UIKit

import SnapKit

class TextCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

// UI 관련을 Extention으로 뺀다라....

extension TextCell {
    func configure() {
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        label.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.contentView).inset(30)
        }
    }
}
