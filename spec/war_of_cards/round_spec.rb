require "spec_helper"

RSpec.describe WarOfCards::Round do
  subject(:round) { described_class.new(players: game.players) }

  let(:game) { WarOfCards::Game.new }
  let(:winning_player) { round.players.to_a.sample }
  let(:loosing_player) { (round.players - [winning_player]).to_a.sample }

  before do
    allow(game).to receive_messages(players: Set.new(
      [winning_player, loosing_player]
    ), current_round: round)
  end

  describe "a standard round" do
    context "when playing a round" do
      it "has all players from the game" do
        expect(round.players.size).to eq(game.players.size)
      end

      it "drawing cards removes cards from hands", :aggregate_failures do
        round.cards_in_play.each do |player_hand|
          expect(
            round.cards_in_play.map { |play| play[:player] }.map(&:hand) & [player_hand[:card]]
          ).to be_empty
        end
      end
    end
  end

  describe "game play" do
    subject(:winners) { round.winners.first }

    before do
      winning_player.hand = Set.new([WarOfCards::Game::Card.new("A", "hearts")])
      loosing_player.hand = Set.new([WarOfCards::Game::Card.new("2", "spades")])

      allow(winning_player).to receive(:merge_winning).with(
        cards: a_kind_of(Set)
      ).and_call_original
    end

    it "determines a winner in a simple round" do
      expect(winners[:player]).to eq(winning_player)
    end

    context "when there is a single winner" do
      it "gives cards in play to winning player" do
        round.winner_takes_cards_in_play(winner: winning_player)
        expect(winning_player).to have_received(:merge_winning).with(cards: a_kind_of(Set))
      end

      it "clears cards in play" do
        round.winner_takes_cards_in_play(winner: winning_player)
        expect(round.cards_in_play).to be_empty
      end
    end
  end
end
