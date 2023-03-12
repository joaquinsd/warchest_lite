require 'game'
RSpec.describe Game do
  let(:player1) {Player.new('Arnold')}
  let(:player2) {Player.new('Bob')}
  subject(:game) { described_class.new(player1, player2) }

  describe '#initialize' do
    it 'creates a new game with two players' do
      expect(game.instance_variable_get(:@player_1)).to eq(player1)
      expect(game.instance_variable_get(:@player_2)).to eq(player2)
    end
  end

  describe '#create_board' do
    it 'creates a new game board and sets up control points' do
      game.create_board
      game_board = game.instance_variable_get(:@game_board)
      expect(game_board).to be_a(Board)
    end
  end
end
