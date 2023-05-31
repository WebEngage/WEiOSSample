//
//  Storage.swift
//  WebEngageInline
//
//  Created by Milind Keni on 21/02/23.
//

import Foundation
class Storage{
    private init() {}
    
    static let instance = Storage()
    
    var currentInlineScreenDataPosition :Int = -1
    var currentSelectedScreen : InlineScreenData? = nil
    
    private let SCREEN_LIST = "screenList"
    private let IS_LOGGED = "isLogged"
    
    func isLogged(isLoggedIn : Bool){
        UserDefaults.standard.set(isLoggedIn, forKey: IS_LOGGED)
    }
    
    func isLogged() -> Bool{
        let isLogged = UserDefaults.standard.bool(forKey: IS_LOGGED)
        return isLogged
    }
    
    func saveListOfScreens(list:Array<InlineScreenData>){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: SCREEN_LIST)
        }
    }
        
    func getListOfScreen()->Array<InlineScreenData>{
        if let data = UserDefaults.standard.data(forKey: SCREEN_LIST) {
                // decode the data into an array of person objects
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([InlineScreenData].self, from: data) {
                    return decoded
                }
            }
            return [InlineScreenData()]
        }
    
    func getScreenData(screenName : String)->InlineScreenData?{
        let list = getListOfScreen()
        for data in list {
            if(data.screenName == screenName){
                return data
            }
        }
        return nil
    }
    
}
