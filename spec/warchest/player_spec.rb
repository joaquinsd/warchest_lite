require 'player'

RSpec.describe Player do
  let(:player) { Player.new("Test Player") }

  describe '#initialize' do
    it 'creates a new player object with default attributes' do
      expect(player.name).to eq "Test Player"
      expect(player.bag).to eq []
      expect(player.hand).to eq []
      expect(player.recruitment).to eq []
      expect(player.control_zone).to eq []
      expect(player.discard_pile).to eq []
      expect(player.board_units).to eq []
      expect(player.control_tokens).to eq 4
      expect(player.initiative).to eq false
    end
  end

  describe '#name' do
    it 'returns the player name' do
      expect(player.name).to eq "Test Player"
    end
  end

  describe '#bag' do
    it 'returns an empty array by default' do
      expect(player.bag).to eq []
    end

    it 'allows the player to add objects to their bag' do
      player.bag << 'Unit_1'
      expect(player.bag).to eq ['Unit_1']
    end
  end

  describe '#hand' do
    it 'returns an empty array by default' do
      expect(player.hand).to eq []
    end

    it 'allows the player to add units to their hand' do
      player.hand << 'Unit_1'
      expect(player.hand).to eq ['Unit_1']
    end
  end

  describe '#initiative' do
    it "doesn't have the initiative by default" do
      expect(player.initiative).to eq false
    end

    it "can get the initiative and get change its value" do
      player.initiative = true
      expect(player.initiative).to eq true
    end


  end
end