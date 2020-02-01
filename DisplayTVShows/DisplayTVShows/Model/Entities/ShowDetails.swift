struct ShowDetails: Decodable {
    var id: Int
    var name: String
    var language: String?
    var genres: [String]?
    var officialSite: String?
    var schedule: ScheduleData?
    var rating: RatingsData?
    var summary: String?
    var image: ImageData?
    var status: String?
}
