module WarOfCards
  class Player
    attr_reader :deck

    def initialize(deck: Set.new)
      @deck = deck || Set.new
    end
  end
end
