module WarOfCards
  class Round
    RANK_VALUES = {
      "Ace" => 14, "King" => 13, "Queen" => 12, "Jack" => 11,
      "10" => 10, "9" => 9, "8" => 8, "7" => 7,
      "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2
    }.freeze

    attr_reader :players

    def initialize(players: Set.new)
      @players = Set.new(players || [])
    end

    def cards_in_play
      @cards_in_play ||= players.each_with_object(Set.new) do |player, acc|
        card = player.draw_cards.first
        acc << {player: player, card: card, card_value: RANK_VALUES[card.rank || card.to_i]}
      end
    end

    def winners
      highest_card = cards_in_play.map { |hand| hand[:card_value] }.max
      cards_in_play.select { |hand| hand[:card_value] == highest_card }
    end

    def winner_takes_cards_in_play(winner:)
      winner.merge_winning(cards: Set.new(cards_in_play.map { |play| play[:card] }))
      @cards_in_play = Set.new
    end
  end
end
