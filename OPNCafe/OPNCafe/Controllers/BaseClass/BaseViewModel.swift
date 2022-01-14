//
//  BaseViewModel.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import Foundation


struct LoadingInfo {
    let isLoading:Bool
    let loadingMessage:String?
    
    init(_ isLoading:Bool, message:String? = nil) {
        self.isLoading = isLoading
        self.loadingMessage = message
    }
}

public class BaseViewModel {
    let isLoading : Box<LoadingInfo> = Box(LoadingInfo(false))
    let errorAlert : Box<ErrorAlert?> = Box(nil)
    
    func showLoading(_ message:String? = nil) {
        self.isLoading.value = LoadingInfo(true, message: message)
    }
    
    func hideLoading() {
        self.isLoading.value = LoadingInfo(false, message: nil)
    }
    
}
