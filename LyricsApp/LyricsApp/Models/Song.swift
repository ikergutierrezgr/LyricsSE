//
//  Song.swift
//  LyricsApp
//
//  Created by Iker Gutierrez.
//

import Foundation

struct Song: Codable {
    var id: UUID
    var artist: String
    var title: String
    var lyrics: String
    
    init (artist: String, title: String, lyrics: String){
        self.id = UUID()
        self.artist = artist
        self.title = title
        self.lyrics = lyrics
    }
    
    static let documentsDirectory =
       FileManager.default.urls(for: .documentDirectory,
       in: .userDomainMask).first!
    
    static let archiveURL =
       documentsDirectory.appendingPathComponent("toDos")
       .appendingPathExtension("plist")
    
    //  Compare artist and song names
    static func == (lhs: Song, rhs: Song) -> Bool {
        return (lhs.artist.lowercased() == rhs.artist.lowercased() && lhs.title
                    .lowercased() == rhs.title.lowercased())
    }
    
    // Compare stored ID
//    static func == (lhs: ToDo, rhs: ToDo) -> Bool {
//        return lhs.id == rhs.id
//    }
    
    static func loadSongs() -> [Song]? {
        guard let codedSongs = try? Data(contentsOf: archiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Song>.self,
           from: codedSongs)
    }
    
    static func saveSongs(_ songsToSave: [Song]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedSongs = try? propertyListEncoder.encode(songsToSave)
        try? codedSongs?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadSampleSongs() -> [Song] {
        let song1 = Song(artist: "Song Artist 1", title: "Song title 1", lyrics: "Lyrics Song 1")
        let song2 = Song(artist: "Song Artist 2", title: "Song title 2", lyrics: "Lyrics Song 2")
        let song3 = Song(artist: "Song Artist 3", title: "Song title 3", lyrics: "Lyrics Song 3")

        return [song1, song2, song3]
    }
}
