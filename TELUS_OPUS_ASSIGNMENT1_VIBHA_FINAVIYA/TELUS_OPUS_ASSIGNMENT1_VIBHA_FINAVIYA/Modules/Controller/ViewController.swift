import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var mainImageView: UIImageView?
    @IBOutlet weak var lblMainDescription: UILabel?
    @IBOutlet weak var lblMainCategory: UILabel?
    @IBOutlet weak var lblMainTitle: UILabel?
    
    //MARK: - Variable Declaration
    
    var arrResult : MoviesDataModel?
    var arrContent = [Container]()
    var imageIndex: Int = 0
    
    //MARK: - ViewController Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    //MARK: - Initialization Method
    private func initialization() {
        arrResult = readJSONFromFile(fileName: "movies", type: MoviesDataModel.self)
        arrContent = arrResult?.resultObj.containers ?? [Container]()
        getRandom()
    }
    
    //MARK: - Read json file Method
    func readJSONFromFile<T: Decodable>(fileName: String, type: T.Type) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    //MARK: - Random movie detail for Top image
    
    func getRandom() {
        var flag: Bool = false
        arrContent.shuffle()
        while flag == false {
            var nextIndex = Int.random(in: 0..<arrContent.count)
            if imageIndex == nextIndex {
                nextIndex = Int.random(in: 0..<arrContent.count)
            } else {
                imageIndex = nextIndex
                flag = true
            }
        }
        let url = URL(string: arrContent[imageIndex].metadata.image23)!
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.mainImageView?.image = UIImage(data: data)
                }
            }
        }
        lblMainTitle?.text = arrContent[imageIndex].metadata.title
        lblMainDescription?.text = arrContent[imageIndex].metadata.longDescription
        lblMainCategory?.text = arrContent[imageIndex].metadata.genres.joined(separator: "•")
        
    }
    
    //MARK: - UIButton Action Method
    
    @IBAction func btnInfoAct(_ sender: Any) {
        let detailScreenController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerName.kDetailScreenController) as? DetailScreenController
        detailScreenController?.arrContent = arrContent[imageIndex]
        self.navigationController?.pushViewController(detailScreenController ?? DetailScreenController(), animated: true)
    }
    
}

// MARK: UICollectionView Delegate & DataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.kpreviewCell, for: indexPath) as! PreViewCell
        let url = URL(string: arrContent[indexPath.row].metadata.image23)!
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    cell.previewImage?.image = UIImage(data: data)
                }
            }
        }
        cell.lblTitle?.text = arrContent[indexPath.row].metadata.title
        cell.lblDescription?.text = arrContent[indexPath.row].metadata.longDescription
        cell.lblCategory?.text = arrContent[indexPath.row].metadata.genres.joined(separator: "•")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreenController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerName.kDetailScreenController) as? DetailScreenController
        detailScreenController?.arrContent = arrContent[indexPath.row]
        self.navigationController?.pushViewController(detailScreenController ?? DetailScreenController(), animated: true)
    }
    
}
