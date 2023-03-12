require 'unit'
RSpec.describe Unit::BasicUnit do
  let(:player) { double("Player") }
  let(:basic_unit) { Unit::BasicUnit.new(player) }

  describe "#initialize" do
    it "sets the owner of the unit" do
      expect(basic_unit.owner).to eq(player)
    end

    it "sets the type of the unit" do
      expect(basic_unit.type).to eq("BasicUnit")
    end
  end

  describe "#validate_movement" do
    it "returns false if the destination is outside the board" do
      expect(basic_unit.validate_movement(0, 0)).to be(false)
      expect(basic_unit.validate_movement(10, 10)).to be(false)
    end

    it "returns false if the destination is the same as the current position" do
      basic_unit.set_location(5, 5)
      expect(basic_unit.validate_movement(5, 5)).to be(false)
    end

    it "returns true if the destination is within the board and different from the current position" do
      basic_unit.set_location(5, 5)
      expect(basic_unit.validate_movement(5, 6)).to be(true)
    end
  end

  describe "#validate_attack" do
    it "returns false if the target is outside the board" do
      expect(basic_unit.validate_attack(0, 0)).to be(false)
      expect(basic_unit.validate_attack(10, 10)).to be(false)
    end

    it "returns false if the target is the same as the current position" do
      basic_unit.set_location(5, 5)
      expect(basic_unit.validate_attack(5, 5)).to be(false)
    end

    it "returns true if the target is within the board and different from the current position" do
      basic_unit.set_location(5, 5)
      expect(basic_unit.validate_attack(5, 6)).to be(true)
    end
  end
end

RSpec.describe Unit::Archer do
  let(:player) { double("Player") }
  let(:archer) { Unit::Archer.new(player) }

  describe "#validate_movement" do
    it "returns true if the destination is within 1 orthogonal range" do
      archer.set_location(5, 5)
      expect(archer.validate_movement(5, 6)).to be(true)
      expect(archer.validate_movement(4, 5)).to be(true)
      expect(archer.validate_movement(5, 4)).to be(true)
    end

    it "returns false if the destination is not within 1 orthogonal range" do
      archer.set_location(5, 5)
      expect(archer.validate_movement(6, 6)).to be(false)
      expect(archer.validate_movement(4, 4)).to be(false)
      expect(archer.validate_movement(1, 1)).to be(false)
    end
  end

  describe "#validate_attack" do
    it "returns true if the target is within 2 adjacent range" do
      archer.set_location(5, 5)
      expect(archer.validate_attack(5, 6)).to be(true)
      expect(archer.validate_attack(4, 5)).to be(true)
      expect(archer.validate_attack(5, 4)).to be(true)
      expect(archer.validate_attack(3, 3)).to be(true)
    end

    it "returns false if the target is not within 2 adjacent range" do
      archer.set_location(5, 5)
      expect(archer.validate_attack(1, 1)).to be(false)
      expect(archer.validate_attack(9, 9)).to be(false)
      expect(archer.validate_attack(8, 4)).to be(false)
    end
  end
end

#This test also applies to Cavalry, Knight, Mercenary && Swordsman
RSpec.describe Unit::Berserker do
  let(:player) { double("Player") }
  let(:berserker) { Unit::Berserker.new(player) }

  describe "#validate_movement" do
    it "returns true if the destination is within 1 orthogonal range" do
      berserker.set_location(5, 5)
      expect(berserker.validate_movement(5, 6)).to be(true)
      expect(berserker.validate_movement(4, 5)).to be(true)
      expect(berserker.validate_movement(5, 4)).to be(true)
    end

    it "returns false if the destination is not within 1 orthogonal range" do
      berserker.set_location(5, 5)
      expect(berserker.validate_movement(6, 6)).to be(false)
      expect(berserker.validate_movement(4, 4)).to be(false)
      expect(berserker.validate_movement(1, 1)).to be(false)
    end
  end

  describe "#validate_attack" do
    it "returns true if the target is within 1 adjacent range" do
      berserker.set_location(5, 5)
      expect(berserker.validate_attack(5, 6)).to be(true)
      expect(berserker.validate_attack(4, 5)).to be(true)
      expect(berserker.validate_attack(5, 4)).to be(true)
    end

    it "returns false if the target is not within 1 adjacent range" do
      berserker.set_location(5, 5)
      expect(berserker.validate_attack(1, 1)).to be(false)
      expect(berserker.validate_attack(9, 9)).to be(false)
      expect(berserker.validate_attack(3, 3)).to be(false)
    end
  end
end

RSpec.describe Unit::Crossbowman do
  let(:player) { double("Player") }
  let(:crossbowman) { Unit::Crossbowman.new(player) }

  describe "#validate_movement" do
    it "returns true if the destination is within 1 orthogonal range" do
      crossbowman.set_location(5, 5)
      expect(crossbowman.validate_movement(5, 6)).to be(true)
      expect(crossbowman.validate_movement(4, 5)).to be(true)
      expect(crossbowman.validate_movement(5, 4)).to be(true)
    end

    it "returns false if the destination is not within 1 orthogonal range" do
      crossbowman.set_location(5, 5)
      expect(crossbowman.validate_movement(6, 6)).to be(false)
      expect(crossbowman.validate_movement(4, 4)).to be(false)
      expect(crossbowman.validate_movement(1, 1)).to be(false)
    end
  end

  describe "#validate_attack" do
    it "returns true if the target is within 2 adjacent range and in straight line" do
      crossbowman.set_location(5, 5)
      expect(crossbowman.validate_attack(3, 5)).to be(true)
      expect(crossbowman.validate_attack(4, 5)).to be(true)
      expect(crossbowman.validate_attack(5, 4)).to be(true)
      expect(crossbowman.validate_attack(5, 3)).to be(true)
    end

    it "returns false if the target is not within 2 adjacent range" do
      crossbowman.set_location(5, 5)
      expect(crossbowman.validate_attack(1, 1)).to be(false)
      expect(crossbowman.validate_attack(9, 9)).to be(false)
      expect(crossbowman.validate_attack(5, 1)).to be(false)
    end
    it "returns false when target is not in a straight line" do
      crossbowman.set_location(5, 5)
      expect(crossbowman.validate_attack(4, 4)).to be(false)
      expect(crossbowman.validate_attack(6, 6)).to be(false)
    end
  end
end

RSpec.describe Unit::Lancer do
  let(:player) { double("Player") }
  let(:lancer) { Unit::Lancer.new(player) }

  describe "#validate_movement" do
    it "returns true if the destination is within 2 orthogonal range" do
      lancer.set_location(5, 5)
      expect(lancer.validate_movement(5, 6)).to be(true)
      expect(lancer.validate_movement(4, 6)).to be(true)
      expect(lancer.validate_movement(6, 6)).to be(true)
    end

    it "returns false if the destination is not within 2 orthogonal range" do
      lancer.set_location(5, 5)
      expect(lancer.validate_movement(7, 6)).to be(false)
      expect(lancer.validate_movement(7, 7)).to be(false)
      expect(lancer.validate_movement(1, 1)).to be(false)
    end
  end

  describe "#validate_attack" do
    it "returns true if the target is within 1 adjacent range" do
      lancer.set_location(5, 5)
      expect(lancer.validate_attack(5, 6)).to be(true)
      expect(lancer.validate_attack(4, 5)).to be(true)
      expect(lancer.validate_attack(5, 4)).to be(true)
    end

    it "returns false if the target is not within 1 adjacent range" do
      lancer.set_location(5, 5)
      expect(lancer.validate_attack(1, 1)).to be(false)
      expect(lancer.validate_attack(9, 9)).to be(false)
      expect(lancer.validate_attack(3, 3)).to be(false)
    end
  end

end