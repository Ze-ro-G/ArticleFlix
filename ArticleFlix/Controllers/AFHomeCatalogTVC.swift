//
//  HomeTableViewController.swift
//  ArticleFlix
//
//  Created by Shaher Kassam on 28/02/16.
//  Copyright © 2016 Shaher Kassam. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class AFHomeCatalogTVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Class Summarry
    //
    // ECRIRE RESUME DE LA CLASS
    // 1 table view
    // Autant de ligne que de titres de section
    // Chaque ligne contient 1 collection view selon son tag
    //
    
    
    // model : 20 Rows, 15 itemsRerRow
    // cover : 4 rows, 11 items per row
    var model: [[UIColor]] = [[UIColor.lightGrayColor()]]
    //let userDef = NSUserDefaults.standardUserDefaults()
    var selectedCell: AFArticleItemCVCell!
    

    // MARK: - Properties

    var _booksUnsorted: [PFObject] = []
    var _categories: [PFObject] = []

    // Library: dictionnaire Category: Livre
    var _library: [String:[PFObject]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HTVC didLoad")

        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background_black")!)
                
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.redColor()]

        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        // Init Titres des sections
        
        // Chargement de la liste des categories et des livres
        getCategories()
        
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        // alors 20
        return _categories.count
        //return model.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? AFHomeCatalogTVCell
        
        // Configure the cell...
        
        // ici tu met le tag car c'est le numero de la cellule de la tableView
        // mais il faut aussi donner le delegate et datasource
        // pour simplifier on les met dans la table view meme si c'est pas le plus MVC possible
        
        
        cell!.collectionView.tag = indexPath.row
        cell!.collectionView.delegate = self
        cell!.collectionView.dataSource = self
        
        cell?.backgroundColor = UIColor.clearColor()
        
        //cell!.textLabel?.text = "cover \(indexPath.row)"
        let values = (_library.values)
        
        let dictKeys = [String](_library.keys)
        cell?.titel.text = dictKeys[indexPath.row]
        cell!.collectionView.reloadData()
        
        return cell!
    }
    
    // CollectionView Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print("Model colection view tag Count: \(model[collectionView.tag].count)")
        //print("Collection view tag: \(collectionView.tag)")
        //tag is the ID of the section. Number of elements in each section
        let dictKeys = [String](_library.keys)
        let title = dictKeys[collectionView.tag]
        let count =  _library[title]!.count
        print("title: \(title)")
        return count
        //return model[collectionView.tag].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AFArticleItemCVCell
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        
        
        let name : String = [String](_library.keys)[collectionView.tag]
        
         var books = self._library[name]! as [PFObject]
        
        let book = books[indexPath.item]
        
        if(collectionView.tag > 2){
            print("#Tag \(collectionView.tag) for Book loaded  \(book.objectForKey("Titre"))")
        }
        if let userImageFile = book["Cover"] as? PFFile{
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.coverImageView.image = UIImage(data:imageData)
                    }
                }
            }
        }

        
        //let image = UIImage(named: timeCovers2015[collectionView.tag][indexPath.item])
        //cell.coverImageView.image = image
        
        //print("cell.back \(cell.backgroundColor)")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let title =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                      withReuseIdentifier: "TitleCRV",
                                                                      forIndexPath: indexPath)
                    as! AFCategoryTitleCRV
            title.label.text = "cover \(indexPath.row)"
            return title
        default:
            //4
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
        //return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // MARK: - Gestion de widget de loading
        //
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Chargement de l'article"

        
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! AFArticleItemCVCell
        print("didSelect color \(selectedCell.backgroundColor)")
        
        
        
        let name : String = [String](_library.keys)[collectionView.tag]
        
        let books = self._library[name]! as [PFObject]
        
        let book = books[indexPath.item]

        
        let selectedBook = book["ePub"] as! PFFile
        
        selectedBook.getDataInBackgroundWithBlock {
            (data: NSData?, error: NSError?) -> Void in
            hud.hide(true)
            if error == nil {
                if let bookData = data {
                    let titre = book["Titre"] as! String
                    let filepath = self.getDocumentsDirectory().stringByAppendingPathComponent("\(titre).epub")
                    print("filepath: \(filepath)")
                    bookData.writeToFile(filepath, atomically: true)
                    self.open(filepath)
                }
            }
            else {
                print("Error:\(error)")}
        }
        
        
        //self.performSegueWithIdentifier("gotoArticle", sender: self)
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        print("logout")
        
        //firebaseRef.unauth()
        
        
        let alert = UIAlertController(title: "Déconnexion", message:"Êtes vous sûr de vouloir vous déconnecter ?", preferredStyle: .Alert)
        let yesA = UIAlertAction(title: "Oui", style: .Default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
            PFUser.logOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDel.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginNC") as! UINavigationController
            
            print("Logout appDel \(appDel)")
            print("Logout root \(appDel.window!.rootViewController)")
        }
        let cancel = UIAlertAction(title: "Non", style: .Default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(cancel)
        alert.addAction(yesA)

        self.presentViewController(alert, animated: true){}

        

        
        /*
         //Save Local
         userDef.setBool(false, forKey: "SignedIn")
         */
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "gotoArticle" {
            
            //if let destination = segue.destinationViewController as? ArticleViewController {
            
            //destination.color = selectedCell.backgroundColor!
            //destination.cover = selectedCell.coverImageView.image!
            //self.open()
            //}
        }
    }
    
    
    
    
    // MARK: - fonctions FolioReader
    //
    func open(path: String) {
        
       
            let config = FolioReaderConfig()
            //let bookPath = NSBundle.mainBundle().pathForResource("bookData", ofType: "ePub")
            FolioReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: config)
     
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func getCategories() {
        
        // MARK: - Gestion de widget de loading
        //
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Chargement de la bibliothèque"
        
        // MARK: - Chargement de la liste des livres
        //
        let query = PFQuery(className:"Category")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            hud.hide(true)
            if error == nil  {
                print("object: \(objects)")
                self._categories = objects!
                for cat in self._categories {
                    let categoryName = cat["Nom"] as! String
                    self._library[categoryName] = []
                }
                self.getBooks()
                //self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    
    }
    
    // MARK: - Charge la liste de livres
    //
    func getBooks() {
        
        // MARK: - Gestion de widget de loading
        //
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Chargement"
        
        // MARK: - Chargement de la liste des livres
        //
        let query = PFQuery(className:"Book")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            hud.hide(true)
            if error == nil  {
                print("object: \(objects)")
                self._booksUnsorted = objects!
                self.model = generateRandomData(self._categories.count, itemsPerRow: self._booksUnsorted.count)
                self.sortBooks()
                //self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }

    // MARK: -Rangement des livres dans les categories
    //
    func sortBooks() {
        for book in _booksUnsorted {
            
            
            if let bookTags = book["Tags"] as? [String] {
                for bookTag in bookTags {
                    _library[bookTag]!.append(book)
                    print("tag: \(bookTag)")
                    print("book: \(book)")
                }
            }

        }
        print("library: \(_library)")
        self.tableView.reloadData()
    }

    
}
