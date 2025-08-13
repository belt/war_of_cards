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
        acc.add({player: player, card: card, card_value: card_value(card)})
      end
    end

    def highest_card = cards_in_play.map { |hand| hand[:card_value] }.max

    # TODO: better name
    def tie_breaker
      tie_breaker_value = cards_in_play.each_with_object(Hash.new(0)) { |hash, counts|
        counts[hash[:card_value]] += 1
      }.reject { |_k, val| val > 1 }.min_by { |(card_val, val)| [-val, -card_val] }&.first
      cards_in_play.detect { |hand| hand[:card_value] == tie_breaker_value }
    end

    def winners
      highest_value = highest_card
      cards_in_play.select { |hand| hand[:card_value] == highest_value }.to_set
    end

    def winner_takes_cards_in_play(winner:)
      winner.merge_winning(cards: cards_in_play.map { |play| play[:card] }.to_set)
      @cards_in_play = Set.new
    end

    def break_ties
      return unless winners.size > 1

      tie_breaker_cards = players.each_with_object(Set.new) do |player, acc|
        cards = player.draw_cards(batch_count: 3)
        cards.each do |card|
          acc.add({player: player, card: card, card_value: card_value(card)})
        end
      end

      @cards_in_play.merge(tie_breaker_cards)
    end

    def card_value(card)
      RANK_VALUES[card.rank || card.to_i]
    end
  end
end
