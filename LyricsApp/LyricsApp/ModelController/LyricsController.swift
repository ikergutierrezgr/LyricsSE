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
    
    var artistName : String = ""
    var songTitle : String = ""
    
    let url = URL(string: "https://api.lyrics.ovh/v1")!
    
    
    
    enum SongControllerError: Error, LocalizedError {
        case lyricsNotFound
    }
    
    func fetchLyrics() async throws -> String{
        
        let lyricsURL = url.appendingPathComponent("/\(artistName.lowercased())/\(songTitle.lowercased())")
        
        print (lyricsURL)
        print (artistName)
        print(songTitle)
        
        // fetch Lyrics
        let (data, response) = try await URLSession.shared.data(from: lyricsURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SongControllerError.lyricsNotFound
        }
        
        let decoder = JSONDecoder()
        let lyricsResponse = try decoder.decode(LyricsResponse.self, from: data)
        
        return lyricsResponse.lyrics
    }
    
}
