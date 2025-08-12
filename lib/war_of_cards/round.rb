module WarOfCards
  class Round
    attr_reader :players

    def initialize(players: Set.new)
      @players = Set.new(players || [])
    end

    def cards_in_play
      @cards_in_play ||= players.each_with_object(Set.new) do |player, acc|
        card = player.draw_cards
        acc << { player: player, card: card }
      end
    end
  end
end
