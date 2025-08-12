module WarOfCards
  class Game
    attr_reader :player_count

    def initialize(player_count: 2)
      @player_count = player_count
    end
  end
end
