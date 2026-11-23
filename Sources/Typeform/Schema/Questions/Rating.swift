public struct Rating: Hashable, Codable, Sendable {

    /*
      TODO: (verify raw values) Star, Heart, Face, Thumbs-Up, Crown, Cat, Dog, Circle, Flag, Drop, Check, Lightbulb, Trophy, Cloud, Lightning, Pencil, Skull
     public enum Shape: String, Sendable, Codable {
         case cat
         case check
         case circle
         case cloud
         case crown
         case dog
         case drop
         case face
         case flag
         case heart
         case lightbulb
         case lightning
         case pencil
         case skull
         case star
         case thumbsUp
         case trophy
     }
      */

    public let shape: String
    public let steps: Int
    public let description: String?

    public init(
        shape: String = "",
        steps: Int = 0,
        description: String? = nil,
    ) {
        self.shape = shape
        self.steps = steps
        self.description = description
    }
}
