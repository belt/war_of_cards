require "spec_helper"

RSpec.describe WarOfCards::Game do
  describe "allows for 2 or 4 players" do
    subject(:game) { described_class.new }

    context "when initializing with defaults" do
      it "player_count is 2" do
        expect(game.player_count).to eq(2)
      end

      it "number of rounds is 0" do
        expect(game.rounds.size).to eq(0)
      end

      it "has a Deck" do
        # NOTE: WarOfCards::Game::Deck is an array as implemented upstream
        expect(game.deck).to be_an(Array)
      end
    end

    context "when initializing to 4" do
      subject(:game) { described_class.new(player_count: 4) }

      it "player_count is 4" do
        expect(game.player_count).to eq(4)
      end
    end

    context "when initializing to other" do
      subject(:game) { described_class.new(player_count: 3) }

      it "throws an error when player_count == 3" do
        expect { game }.to raise_error(WarOfCards::Error)
      end

      it "throws an error when player_count == '2'" do
        expect {
          described_class.new(player_count: "2")
        }.to raise_error(WarOfCards::Error)
      end
    end
  end

  describe "2-player mode" do
    subject(:game) { described_class.new }

    context "when initializing players" do
      subject(:players) { game.players }

      it "creates 2 players" do
        expect(players.size).to eq(2)
      end
    end

    context "when dealing cards" do
      subject(:player) { game.players.to_a.sample }

      it "initializes 26 cards per player" do
        expect(player.hand.size).to be(26)
      end
    end
  end

  describe "4-player mode" do
    subject(:game) { described_class.new(player_count: 4) }

    context "when initializing players" do
      subject(:players) { game.players }

      it "creates 4 players" do
        expect(players.size).to eq(4)
      end
    end

    context "when dealing cards" do
      subject(:player) { game.players.to_a.sample }

      it "deals 13 cards per player" do
        expect(player.hand.size).to be(13)
      end
    end
  end

  describe "#game_over?" do
    subject(:game) { described_class.new(player_count: 4) }

    before do
      game.players.to_a[1..].each do |player|
        player.status = :lost
      end
    end

    it "yields true when there is only 1 player sitting" do
      expect(game.game_over?).to be(true)
    end
  end
end
