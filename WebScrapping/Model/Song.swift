//
//  Song.swift
//  WebScrapping
//
//  Created by Alex Lopez on 13/11/2018.
//  Copyright © 2018 Cristian Lopez. All rights reserved.
//

import Foundation

class Song {
    
    var uuid: String
    var title : String
    var authorName : String
    var itunesUrl : String
    var imgUrl : String
    var imageDownloaded = false
    
    init(title: String, authorName: String, itunesUrl: String) {
        
        self.uuid = UUID().uuidString
        self.authorName = authorName
        self.title = title
        self.itunesUrl = itunesUrl
        self.imgUrl = ""
    }
    
    init(title: String, authorName: String, itunesUrl: String, imgUrl: String = "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/2f/ee/52/2fee52de-5947-dd83-ba88-fc5bdbd72c75/093155174290_cover.jpg/268x0w.jpg") {
        
        self.uuid = UUID().uuidString
        self.title = title
        self.authorName = authorName
        self.itunesUrl = itunesUrl
        self.imgUrl = imgUrl
    }
}
