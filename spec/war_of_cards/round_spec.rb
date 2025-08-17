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
    context "when there is a single winner" do
      before do
        winning_player.hand = [WarOfCards::Game::Card.new("A", "hearts")].to_set
        loosing_player.hand = [WarOfCards::Game::Card.new("2", "spades")].to_set

        allow(winning_player).to receive(:merge_winning).with(
          cards: a_kind_of(Set)
        ).and_call_original
      end

      it "determines a winner in a simple round" do
        expect(round.winners.first[:player]).to eq(winning_player)
      end

      it "gives cards in play to winning player" do
        round.winner_takes_cards_in_play(winner: winning_player)
        expect(winning_player).to have_received(:merge_winning).with(cards: a_kind_of(Set))
      end

      it "clears cards in play" do
        round.winner_takes_cards_in_play(winner: winning_player)
        expect(round.cards_in_play).to be_empty
      end
    end

    context "when there are no winners" do
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
          WarOfCards::Game::Card.new("K", "clubs"),
          WarOfCards::Game::Card.new("9", "spades"),
          WarOfCards::Game::Card.new("8", "spades")
        ].to_set
      end

      it "detects ties" do
        expect(round.winners.size).to eq(game.players.count)
      end

      it "resolves ties adding 4x cards per player" do
        expect { round.break_ties }.to change {
          round.cards_in_play.size
        }.by(4 * game.players.size)
      end

      it "breaks simple ties", :aggregate_failures do
        expect(round.winners.size).to eq(2)
        round.break_ties
        expect(round.winners.size).to eq(1)
      end

      it "breaking ties chooses the correct winner" do
        round.break_ties
        winner = round.winners.first

        expect(winner[:player]).to eq(winning_player)
      end
    end

    # rubocop:disable RSpec/TooManyExampleLines
    context "when multiple rounds of tie-breaking are needed" do
      let(:alice) {
        instance_double(
          WarOfCards::Player, hand: Set.new,
          draw_cards: Set.new([WarOfCards::Game::Card.new("A", "hearts")])
        )
      }
      let(:bob) {
        instance_double(
          WarOfCards::Player, hand: Set.new,
          draw_cards: Set.new([WarOfCards::Game::Card.new("A", "spades")])
        )
      }

      before do
        # Mock the merge_winning method to prevent actual card transfer
        allow(alice).to receive(:merge_winning)
        allow(bob).to receive(:merge_winning)

        allow(game).to receive_messages(
          players: [alice, bob].to_set, current_round: round
        )
      end

      it "breaks repeated ties" do
        # Mock the draw_cards method to return cards with same rank values
        # to force multiple tie-breaking rounds
        alice_first_draw = [
          WarOfCards::Game::Card.new(7, "hearts"),
          WarOfCards::Game::Card.new(8, "hearts"),
          WarOfCards::Game::Card.new(9, "hearts"),
          WarOfCards::Game::Card.new("K", "hearts")
        ].to_set

        bob_first_draw = [
          WarOfCards::Game::Card.new(1, "spades"),
          WarOfCards::Game::Card.new(2, "spades"),
          WarOfCards::Game::Card.new(3, "spades"),
          WarOfCards::Game::Card.new("K", "spades")
        ].to_set

        # First draw will have ties, second draw will also have ties
        allow(alice).to receive(:draw_cards).with(batch_count: 3).and_return(alice_first_draw)
        allow(bob).to receive(:draw_cards).with(batch_count: 3).and_return(bob_first_draw)

        # First round of tie-breaking
        round.break_ties

        # Mock the card_value method to return same values for both players
        # in both draws to ensure tie continues through multiple rounds
        alice_second_draw = [
          WarOfCards::Game::Card.new(4, "hearts"),
          WarOfCards::Game::Card.new(2, "hearts"),
          WarOfCards::Game::Card.new(6, "hearts"),
          WarOfCards::Game::Card.new(9, "hearts")
        ].to_set

        bob_second_draw = [
          WarOfCards::Game::Card.new(6, "spades"),
          WarOfCards::Game::Card.new(9, "spades"),
          WarOfCards::Game::Card.new(7, "spades")
        ].to_set

        # Simulate another round
        allow(alice).to receive(:draw_cards).and_return(alice_second_draw)
        allow(bob).to receive(:draw_cards).and_return(bob_second_draw)

        # Second round of tie-breaking
        round.break_ties

        # Verify that multiple rounds of tie-breaking were processed
        expect(round.winners.size).to eq(1)
      end
    end
    # rubocop:enable RSpec/TooManyExampleLines
  end
end
