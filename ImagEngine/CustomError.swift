//
//  CustomErrors.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/26/22.
//

import Foundation

enum CustomError: String, Error {
    case unableToFavorite = "There was an error favoriting this user. Please try again!"
    case alreadyInFavorite = "You already favorited this user."
}
