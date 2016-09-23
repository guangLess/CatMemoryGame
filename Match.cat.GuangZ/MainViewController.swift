//
//  MainViewController.swift
//  Match.cat.GuangZ
//
//  Created by Guang on 7/7/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var testPHotoSet = [Photo]()
    var deck = Deck()
    let catDataStore = APIClient.sharedInstance
    var currentSet = [UIImage]()
    var scoreCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPCollectionView()
        populateDataCat()
    }
    //MARK: setupCollectionView
    func setUPCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenBound = UIScreen.mainScreen().bounds
        let width = screenBound.size.width
        layout.itemSize = CGSize(width:(width)/4, height: (width)/4)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    //MARK: getData
    func populateDataCat(){
        catDataStore.apiClient { (result, array) in
            //self.testCatImage.image = self.catDataStore.deck.imageList.last
            dispatch_async(dispatch_get_main_queue(),{
            self.currentSet = self.updateData(self.catDataStore.deck.imageList)
            self.collectionView.reloadData()
            })
        }
    }
    func updateData(testImageSet: [UIImage]) -> [UIImage] {
        //let testImageSet = [UIImage(named: "book")!, UIImage(named: "suitcase")!,UIImage(named: "hoodie")!,UIImage(named: "record")!]
        print(testImageSet.last)
        let cardOne = deck.shuffle(testImageSet)
        let cardTwo = deck.shuffle(testImageSet)
        let wholeSet = cardOne + cardTwo
        print(wholeSet)
        return wholeSet
    }
    //MARK:collectionView delegate/Datastore
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CatCollectionViewCell
        //cell.cellImageView.hidden = true
        cell.cellImageView.alpha = 1
        let image = currentSet[indexPath.row]
        cell.cellImageView.image = image
        return cell
    }
    
    var selectedImages = [UIImage]()//only have two ints TOFIX: change to collect cells
    var previousLabel = UIImage()
    var previousCell = CatCollectionViewCell()
    var currentIndex = 0
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! CatCollectionViewCell
        selectedCell.cellLabel.fadeOut()
        let currentLabel = currentSet[indexPath.row]
        print(currentIndex)
        if (currentIndex == indexPath.row){ //|| (indexPath.row == 0 && currentIndex == 0)){
            print("same index selected")
            previousLabel = currentLabel
            previousCell = selectedCell
            selectedCell.cellLabel.fadeIn()
          } else {
            print(currentIndex)
            selectedImages.removeAll()
            currentIndex = indexPath.row
            selectedImages.append(currentLabel)
            selectedImages.append(previousLabel)
            //comepare Images
    
            let checkTwoImages = compareTwoUIImage(selectedImages.first!, b: selectedImages.last!)
             if ((selectedImages.isEmpty == false) && (checkTwoImages == true )){
                disableMatchedCell(selectedCell, b:previousCell, indexPath: indexPath)
                print ("-------Match🖖🏽😡Found------")
                scoreCount+=1 //FIXME: make a globle varible for static number
                scoreLabel.text = String(format: "🖖🏽%i",scoreCount)
                if scoreCount == 8 {
                    alertForWinAction()
                }
            }
            previousCell = selectedCell
            previousLabel = currentLabel
        }
        selectedCell.cellLabel.fadeIn()
    }
    //MARK:checkMatchData
    func disableMatchedCell(a:CatCollectionViewCell, b:CatCollectionViewCell, indexPath: NSIndexPath){
        a.selected = true
        a.cellLabel.text = "X"
        a.cellLabel.backgroundColor = UIColor.clearColor()
        a.userInteractionEnabled = false
        b.cellLabel.text = "X"
        b.cellLabel.backgroundColor = UIColor.clearColor()
        b.userInteractionEnabled = false
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    func compareTwoUIImage(a: UIImage, b: UIImage) -> Bool{
        if let aData = UIImagePNGRepresentation(a){
            if let bData = UIImagePNGRepresentation(b){
                return aData.isEqual(bData)
            }
        }
        return false
    }
    //MARK: AlertAction
    func alertForWinAction () {
        let alertController = UIAlertController(title: "all cats matched", message: "🐱", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "refresh", style: .Default) {
            (action) in
        self.populateDataCat() //FIXME:reloatData not working
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}