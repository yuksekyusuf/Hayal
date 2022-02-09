//
//  CustomErrors.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/26/22.
//

import Foundation

enum CustomError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again!"
    case alreadyInFavorite = "Already saved"
}
