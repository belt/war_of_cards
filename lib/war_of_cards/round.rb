module WarOfCards
  class Round
    attr_reader :players

    def initialize(players: Set.new)
      @players = Set.new(players || [])
    end
  end
end
