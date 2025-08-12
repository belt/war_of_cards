require "spec_helper"

RSpec.describe WarOfCards::Player do
  describe "player has hand" do
    subject(:player) { described_class.new }

    context "when initializing with defaults" do
      it "has a hand" do
        expect(player.hand).to be_a(Set)
      end
    end
  end
end
