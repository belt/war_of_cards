require "spec_helper"

RSpec.describe WarOfCards::Round do
  subject(:round) { described_class.new(players: game.players) }

  let(:game) { WarOfCards::Game.new }
  let(:winning_player) { round.players.to_a.sample }
  let(:loosing_player) { (round.players - [winning_player]).to_a.sample }

  before do
    allow(game).to receive_messages(
      players: [winning_player, loosing_player].to_set,
      current_round: round
    )
  end

  describe "a standard round" do
    context "when playing a round" do
      it "has all players from the game" do
        expect(round.players.size).to eq(game.players.size)
      end

      it "drawing cards removes cards from hands", :aggregate_failures do
        round.cards_in_play.each do |player_hand|
          expect(
            round.cards_in_play.map { |play|
              play[:player]
            }.map(&:hand).to_set & [player_hand[:card]].to_set
          ).to be_empty
        end
      end
    end
  end

  describe "game play" do
    subject(:winners) { round.winners.first }

    before do
      winning_player.hand = [WarOfCards::Game::Card.new("A", "hearts")].to_set
      loosing_player.hand = [WarOfCards::Game::Card.new("2", "spades")].to_set

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

    context "when there no winners" do
      before do
        winning_player.hand = winning_cards
        loosing_player.hand = loosing_cards
      end

      let(:winning_cards) do
        [
          WarOfCards::Game::Card.new("A", "hearts"),
          WarOfCards::Game::Card.new("K", "hearts"),
          WarOfCards::Game::Card.new("Q", "hearts"),
          WarOfCards::Game::Card.new("J", "hearts"),
          WarOfCards::Game::Card.new("9", "hearts")
        ].to_set
      end
      let(:loosing_cards) do
        [
          WarOfCards::Game::Card.new("A", "spades"),
          WarOfCards::Game::Card.new("K", "spades"),
          WarOfCards::Game::Card.new("J", "spades"),
          WarOfCards::Game::Card.new("9", "spades"),
          WarOfCards::Game::Card.new("8", "spades")
        ].to_set
      end

      it "detects ties" do
        expect(round.winners.size).to eq(game.players.count)
      end

      it "resolves ties adding 3x cards per player" do
        expect { round.break_ties }.to change {
          round.cards_in_play.size
        }.by(3 * game.players.size)
      end

      it "detects tie-breakers", :aggregate_failures do
        round.break_ties

        tie_breaker = round.tie_breaker
        expect(tie_breaker[:player]).to eq(winning_player)
        expect(tie_breaker[:card_value]).to eq(12)
        expect(tie_breaker[:card].suit).to eq("Hearts")
      end

      context "when there no tie-breakers" do
        before do
          winning_player.hand = player1_cards
          loosing_player.hand = player2_cards
        end

        let(:player1_cards) do
          [
            WarOfCards::Game::Card.new("A", "hearts"),
            WarOfCards::Game::Card.new("K", "hearts"),
            WarOfCards::Game::Card.new("Q", "hearts")
          ].to_set
        end
        let(:player2_cards) do
          [
            WarOfCards::Game::Card.new("A", "spades"),
            WarOfCards::Game::Card.new("K", "spades"),
            WarOfCards::Game::Card.new("Q", "spades")
          ].to_set
        end

        it "detects no tie-breakers", :aggregate_failures do
          round.break_ties

          expect(round.tie_breaker).to be_nil
        end
      end
    end
  end
end
