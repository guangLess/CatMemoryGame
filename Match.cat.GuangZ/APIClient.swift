//
//  APIClient.swift
//  Match.cat.GuangZ
//
//  Created by Guang on 7/13/16.
//  Copyright © 2016 Guang. All rights reserved.

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class APIClient {
    static let sharedInstance = APIClient()
    var deck = Deck()

    func apiClient(completion: (result:Bool,array:[Photo]) -> Void){
        //self.deck.cardAmount = 8
        /*
        let api_key = "5423dbab63f23a62ca4a986e7cbb35e2"
        let URLRequestString = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
        let tags = "kitten"
        let sort = "date-posted-desc-desc"
        let perPage = "8"
        let formate = "json"
        let nojsoncallback = 1
        let extras = "url_q"
        
        let parameters = [ "api_key" : api_key,
                           "tags":tags,
                           "sort":sort,
                           "per_page":perPage,
                           "formate":formate,
                           "nojsoncallback":nojsoncallback,
                           "extras":extras]
        */
        let stringURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5423dbab63f23a62ca4a986e7cbb35e2&tags=kitten&sort=date-posted-desc-desc&per_page=8&format=json&nojsoncallback=1&extras=url_q"
        let nsURL = NSURL(string: stringURL)!
        Alamofire.request(.GET, nsURL,parameters:nil)
            .validate()
            .responseJSON { response in
                switch response.result{
                case .Success:
                    print("success")
                    _ = response.result.value.map({ photo in
                        _ = photo["photos"].map{ photos in
                            if let photoList = photos["photo"]{
                                _ = photoList.map({ photoList in
                                    print(photoList)
                                    var remainingCount = self.deck.cardAmount
                                    for each in photoList as! [AnyObject]{
                                        remainingCount-=1
                                        print("---------\(each)------")
                                        print("remainingCount --- \(self.deck.imageList.count)")
                                        let eachPhoto = self.addPhotoToPhotoList(each as! Dictionary)
                                        self.deck.photoList.append(eachPhoto)
                                        self.requestImage(eachPhoto, completion: { (success) in
                                            if (self.deck.imageList.count == 8) {
                                                completion(result: true, array: self.deck.photoList)
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    })
                case .Failure(let error):
                    print(error)
                }
        }
    }
    private func addPhotoToPhotoList(photoInfo: [String: AnyObject]) -> Photo {
        let photo = Photo(farm: photoInfo["farm"] as! Int, secret: photoInfo["secret"] as! String, id: photoInfo["id"] as! String, server: photoInfo["server"] as! String, url_q: photoInfo["url_q"] as! String)
        return photo
    }
    func requestImage(photo: Photo, completion: (success:Bool) -> Void) {
        let eachImageURL = NSURL(string: photo.url_q)!
        print(eachImageURL)
        Alamofire.request(.GET, eachImageURL, parameters: nil)
            .responseImage { response in
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.deck.imageList.append(image)
                    completion(success: true)
                }
        }
    }
}