require "spec_helper"

RSpec.describe WarOfCards::Player do
  describe "player has hand" do
    subject(:player) { described_class.new }

    context "when initializing with defaults" do
      it "has a hand" do
        expect(player.hand).to be_a(Set)
      end
    end

    context "when initializing with a status" do
      subject(:player) { described_class.new(status: :sitting) }

      it "records valid status" do
        expect(player.status).to eq(:sitting)
      end

      it "validates status" do
        WarOfCards::Player::VALID_STATUSII.each do |status|
          player.status = status
          expect(player.valid_status?).to be(true)
        end
      end

      it "raises an error on invalid status" do
        player.status = :invalid
        expect {
          player.handle_invalid_status
        }.to raise_error(WarOfCards::Error)
      end
    end
  end

  describe "#draw_cards" do
    subject(:player) { described_class.new(hand: cards) }

    let(:cards) do
      [
        WarOfCards::Game::Card.new("A", "hearts"),
        WarOfCards::Game::Card.new("K", "spades"),
        WarOfCards::Game::Card.new("Q", "clubs")
      ].to_set
    end
    let(:cards_to_draw) { 1 }
    let(:cards_drawn) { player.draw_cards(batch_count: cards_to_draw) }

    it "draws one card by default" do
      expect(cards_drawn).to eq([cards.first].to_set)
    end

    context "when drawing multiple cards" do
      let(:cards_to_draw) { 2 }

      it "draws specified number of cards" do
        expect(cards_drawn).to eq(
          cards.to_a[0..cards_to_draw - 1].to_set
        )
      end

      it "removes cards from hand when drawing cards" do
        expect(cards_drawn & player.hand).to be_empty
      end
    end

    context "when batch_count is higher than remaining cards" do
      let(:cards_to_draw) { 5 }

      it "draws all remaining cards" do
        expect(cards_drawn).to eq(cards)
      end

      it "has lost if a player can not draw batch_count cards" do
        expect {
          player.draw_cards(batch_count: 6)
        }.to change(player, :status).to(:lost)
      end
    end
  end

  describe "#merge_winning" do
    subject(:winning_player) { described_class.new(hand: winning_cards) }

    let(:winning_cards) do
      [
        WarOfCards::Game::Card.new("A", "hearts"),
        WarOfCards::Game::Card.new("K", "spades"),
        WarOfCards::Game::Card.new("Q", "clubs")
      ].to_set
    end

    let(:cards_in_play) do
      [
        WarOfCards::Game::Card.new("J", "diamonds"),
        WarOfCards::Game::Card.new("10", "clubs"),
        WarOfCards::Game::Card.new("9", "clubs")
      ].to_set
    end

    context "when player has winning hand" do
      it "acquires cards in play" do
        winning_player.merge_winning(cards: cards_in_play)

        expect(winning_player.hand & cards_in_play).to match_array(
          cards_in_play
        )
      end
    end
  end
end
