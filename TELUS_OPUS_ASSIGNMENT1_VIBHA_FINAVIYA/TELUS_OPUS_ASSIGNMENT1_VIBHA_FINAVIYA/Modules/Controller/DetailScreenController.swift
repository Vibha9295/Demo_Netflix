import UIKit
import CoreData

class DetailScreenController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgMain: UIImageView?
    
    @IBOutlet weak var lblDuration: UILabel?
    @IBOutlet weak var lblRating: UILabel?
    @IBOutlet weak var lblYear: UILabel?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblDescription: UILabel?
    @IBOutlet weak var lblCategory: UILabel?
    
    @IBOutlet weak var btnFavOut: UIButton?
    
    //MARK: - Variable Declaration
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var arrContent : Container?
    var isFav = false
    
    //MARK: - ViewController Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    //MARK: - Initialization Method
    private func initialization() {
        
        let url = URL(string: self.arrContent?.metadata.iconicImage169 ?? "")!

            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        self.imgMain?.image = UIImage(data: data)
                    }
                }
            }
        
        self.lblTitle?.text = self.arrContent?.metadata.title
        self.lblDescription?.text = self.arrContent?.metadata.longDescription
        self.lblYear?.text = self.arrContent?.metadata.year
        self.lblRating?.text = self.arrContent?.metadata.rating
        self.lblDuration?.text = self.arrContent?.metadata.duration.secondsToTime()
        self.lblCategory?.text = arrContent?.metadata.genres.joined(separator: "•")
        self.btnFavOut?.layer.cornerRadius = 5
        retrieveData()
        
    }
    
    //MARK: - Core data Methods
    
    func insertUpdateData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        let movies: Movies!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        fetchRequest.predicate = NSPredicate(format: "(id = %@)", self.arrContent!.id)
        let results = try? managedContext.fetch(fetchRequest)
        
        if results?.count == 0 {
            // Insert
            movies = Movies(context: managedContext)
            user.setValue(arrContent?.id, forKey: "id")
            user.setValue(isFav, forKey: "isFav")
            self.btnUpdate(isSelected: self.isFav)
            
        } else {
            // Update
            movies = results?.first as? Movies
            movies.isFav = isFav
            DispatchQueue.main.async {
                self.btnUpdate(isSelected: self.isFav)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        do {
            let result = try managedContext.fetch(fetchRequest)
            var arr = [[String:AnyObject]]()
            for data in result as! [NSManagedObject] {
                var obj = [String:AnyObject]()
                obj["id"] = data.value(forKey: "id") as AnyObject
                obj["isFav"] = data.value(forKey: "isFav") as AnyObject
                arr.append(obj)
            }
            for i in arr{
                if i["id"] as! String == arrContent?.id ?? "0"{
                    isFav = i["isFav"]! as! Bool
                    DispatchQueue.main.async {
                        self.btnUpdate(isSelected: self.isFav)
                    }
                }
            }
        } catch {
            
            print("Failed")
        }
    }
    func btnUpdate(isSelected : Bool){
        self.btnFavOut?.tintColor = isSelected == true ? .red : .white
        self.btnFavOut?.backgroundColor = isSelected == true ? .white : .red
        self.btnFavOut?.setTitleColor(isSelected == true ? .red : .white, for: .normal)
        self.btnFavOut?.setTitle(isSelected == true ? " Remove Favorite" : " Add to Favorite", for: .normal)
    }
    //MARK: - UIButton Action Method
    @IBAction func btnCloseAct(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        
    }
    @IBAction func btnBackAct(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    @IBAction func btnFavAct(_ sender: Any) {
        isFav = !isFav
        insertUpdateData()
    }
    
}
