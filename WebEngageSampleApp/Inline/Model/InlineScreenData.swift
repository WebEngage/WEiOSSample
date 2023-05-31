//
//  InlineScreenData.swift
//  WebEngageInline
//
//  Created by Milind Keni on 21/02/23.
//

class InlineScreenData : Codable{
    var listSize = 20
    var screenName = ""
    var event = ""
    var screenAttribute = ""
    var isRecycledView = false
    var listOfInlineWidgetData : Array<InlineWidgetData> = []
}

class InlineWidgetData : Codable{
    var  position = -1
    var iosPropertyId = -1
    var viewWidth = 0
    var viewHeight = 0
    var isCustomView = false
    
}
