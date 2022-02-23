//
//  SongController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez.
//

import Foundation
import UIKit

class LyricsController {
    
    static let shared = LyricsController()
    
//    let baseURL = URL(string: "https://api.lyrics.ovh/v1/")!
    let url = URL(string: "https://api.lyrics.ovh/v1/Coldplay/yellow")!
    
    
    
    enum SongControllerError: Error, LocalizedError {
        case lyricsNotFound
    }
    
    func fetchLyrics() async throws -> String{
        
        let songURL = url
        
        // fetch Lyrics
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SongControllerError.lyricsNotFound
        }
        
        let decoder = JSONDecoder()
        let lyricsResponse = try decoder.decode(LyricsResponse.self, from: data)
        
        
        return lyricsResponse.lyrics
    }
    
}
