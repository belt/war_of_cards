require "spec_helper"

RSpec.describe WarOfCards::Game do
  describe "allows for 2 or 4 players" do
    subject(:game) { described_class.new }

    context "when initalizing with defaults" do
      it "player_count is 2" do
        expect(game.player_count).to eq(2)
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

    context "when initalizing players" do
      subject(:players) { game.players }

      it "creates 2 players" do
        expect(players.size).to eq(2)
      end
    end

    context "when dealing cards" do
      it "deals 26 cards per player", skip: "TODO" do
        expect(false).to eq(true)
      end
    end
  end

  describe "4-player mode" do
    subject(:game) { described_class.new(player_count: 4) }

    context "when initalizing players" do
      subject(:players) { game.players }

      it "creates 4 players" do
        expect(players.size).to eq(4)
      end
    end

    context "when dealing cards" do
      it "deals 13 cards per player", skip: "TODO" do
        expect(false).to eq(true)
      end
    end
  end
end
