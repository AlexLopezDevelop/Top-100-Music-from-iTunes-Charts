//
//  SongsFactory.swift
//  WebScrapping
//
//  Created by Alex Lopez on 13/11/2018.
//  Copyright © 2018 Cristian Lopez. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class SongsFactory {
    var songs = [Song]()
    var songsUrl: String
    var completedSongs = 0
    var totalDownloadedSongs = 0
    
    init(songsUrl: String) {
        self.songsUrl = songsUrl
        scrapeUrl()
    }
    
    func scrapeUrl() {
        Alamofire.request(self.songsUrl).responseString { (response) in
            if response.result.isSuccess {
                if let htmlString = response.result.value {
                    self.parseHTML(html: htmlString)
                }
            }
        }
    }
    
    func parseHTML(html: String){
        
        do{
            let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            
            for div in doc.css("div"){
                if div["class"] == "section-content"{
                    for ul in div.css("ul"){
                        for li in ul.css("li"){
                            var title : String = ""
                            var authorName : String = ""
                            var url : String = ""
                            
                            for h3 in li.css("h3"){
                                title = h3.text!
                                break
                            }
                            
                            for h4 in li.css("h4"){
                                authorName = h4.text!
                                break
                            }
                            
                            for a in li.css("a"){
                                if a["class"] == "more"{
                                    url = a["href"]!
                                    break
                                }
                            }
                            
                            let song = Song(title: title, authorName: authorName, itunesUrl: url)
                            self.songs.append(song)
                            
                            NotificationCenter.default.post(name: NSNotification.Name("SongsUpdated"), object: nil)
                            
                        }
                    }
                }
            }
            
            self.downloadStaticDataCompleted()
            
        }catch{
            print(error)
        }
    }
    
    func downloadStaticDataCompleted() {
        self.totalDownloadedSongs = 10
        for i in 0 ..< self.totalDownloadedSongs {
            DispatchQueue.main.async() {
                self.getImageByUrl(self.songs[i])
            }
        }
    }
    
    func downloadMoreItems() {
        if self.totalDownloadedSongs < self.songs.count {
            self.totalDownloadedSongs += 10
            for i in self.totalDownloadedSongs - 10 ..< self.totalDownloadedSongs {
                DispatchQueue.main.async() {
                    self.getImageByUrl(self.songs[i])
                }
            }
        }
    }
    
    func getImageByUrl(_ song: Song) {
        Alamofire.request(song.itunesUrl).responseString { (response) in
            if response.result.isSuccess {
                if let htmlString = response.result.value {
                    self.parseImageForHTML(htmlString: htmlString, forSong: song.uuid)
                }
            }
        }
    }
    
    func parseImageForHTML(htmlString: String, forSong id: String){
        do{
            let doc = try Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8)
            
            
            let regex = "^we-artwork__image"
            
            for img in doc.css("img"){
                
                if img["class"]?.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil{
                    
                    if img["src"]?.range(of: "^(\\w|\\W)+\\/image\\/thumb\\/(\\w|\\W)+\\.jpe?g$", options: .regularExpression, range: nil, locale: nil) != nil {
                        
                        for song in self.songs{
                            if song.uuid == id {
                                song.imgUrl = img["src"]!
                                song.imageDownloaded = true
                                NotificationCenter.default.post(name: NSNotification.Name("SongsUpdated"), object: nil)
                                
                                self.checkCompletionStatus(forSong: id)
                                
                                break
                            }
                        }
                        
                        break
                    }
                }
            }
            
        }catch{
            print(error)
        }
    }
    
    func checkCompletionStatus(forSong id: String){
        self.completedSongs += 1
        print("Estado de completación : \(self.completedSongs) / \(self.songs.count)")
        if self.completedSongs % 10 == 0{
            self.downloadMoreItems()
        }
    }
    
}
