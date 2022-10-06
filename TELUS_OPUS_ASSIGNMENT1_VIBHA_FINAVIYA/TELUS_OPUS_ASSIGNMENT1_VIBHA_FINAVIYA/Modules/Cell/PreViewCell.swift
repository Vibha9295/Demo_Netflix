import UIKit

class PreViewCell: UICollectionViewCell {
    
    //MARK: -  Outlets
    
    @IBOutlet weak var previewImage: UIImageView?
    @IBOutlet weak var lblCategory: UILabel?
    @IBOutlet weak var lblDescription: UILabel?
    @IBOutlet weak var lblTitle: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
