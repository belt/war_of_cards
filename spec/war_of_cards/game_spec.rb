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

      it "throws an error" do
        expect { game }.to raise_error(WarOfCards::Game::Error)
      end
    end
  end
end
