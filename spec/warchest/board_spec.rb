require 'board'
require 'player'
RSpec.describe Board do
  let(:board_size) { 9 }
  let(:board) { Board.new(board_size) }
  let(:player_1) { Player.new('Alice')}
  let(:player_2) { Player.new('Bob') }

  describe '#initialize' do
    it 'creates a 2D array with size board_size + 1' do
      expect(board.instance_variable_get(:@board).size).to eq(board_size + 1)
      expect(board.instance_variable_get(:@board).all? { |row| row.size == board_size + 1 }).to be true
    end
  end

  describe '#fill_board' do
    it 'fills the board with appropriate headers and free control zones' do
      board.fill_board
      expect(board.instance_variable_get(:@board)[0]).to eq(['   ', ' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ', ' 7 ', ' 8 ', ' 9 '])
      expect(board.instance_variable_get(:@board)[1][0]).to eq(' a ')
      expect(board.instance_variable_get(:@board)[9][0]).to eq(' i ')
      expect(board.instance_variable_get(:@board)[1][1]).to eq(' . ')
      expect(board.instance_variable_get(:@board)[9][9]).to eq(' . ')
      expect(board.instance_variable_get(:@board)[4][2]).to eq(' @ ')
      expect(board.instance_variable_get(:@board)[4][4]).to eq(' @ ')
      expect(board.instance_variable_get(:@board)[4][7]).to eq(' @ ')
      expect(board.instance_variable_get(:@board)[6][3]).to eq(' @ ')
      expect(board.instance_variable_get(:@board)[6][6]).to eq(' @ ')
      expect(board.instance_variable_get(:@board)[6][8]).to eq(' @ ')
    end
  end

  describe '#setup_control_points' do
    it 'sets the control zone coordinates for both players' do
      board.fill_board
      board.setup_control_points(player_1, player_2)
      expect(board.instance_variable_get(:@board)[1][3]).to eq(' A ')
      expect(board.instance_variable_get(:@board)[1][7]).to eq(' A ')
      expect(board.instance_variable_get(:@board)[9][3]).to eq(' B ')
      expect(board.instance_variable_get(:@board)[9][7]).to eq(' B ')
      expect(player_1.control_zone).to eq([[1, 3], [1, 7]])
      expect(player_2.control_zone).to eq([[9, 3], [9, 7]])
    end
  end

  describe '#place_unit' do
    it 'places the unit at the specified location on the board' do
      board.place_unit(1, 1, 'Archer')
      expect(board.instance_variable_get(:@board)[1][1]).to eq('Ar ')
    end
  end

  describe "#remove_unit" do
    before do
      board.fill_board
      board.setup_control_points(player_1, player_2)
      board.place_unit(1,1, 'Archer')
      board.place_unit(1, 3, 'Lancer')
      board.place_unit(9, 3, 'Knight')
    end

    context "when removed unit is on a empty zone" do
      it "removes the unit from the board and replaces it with a single dot" do
        board.remove_unit(1,1, [player_1, player_2])
        expect(board.instance_variable_get(:@board)[1][1]).to eq(' . ')
      end
    end

    context "when removed unit is on player_1 control zone" do
      it "removes the unit from the board and replaces it with player_1's control token" do
        board.remove_unit(1,3, [player_1, player_2])
        expect(board.instance_variable_get(:@board)[1][3]).to eq(' A ')
      end
    end

    context "when removed unit is on player_2 control zone" do
      it "removes the unit from the board and replaces it with player_2's control token" do
        board.remove_unit(9,3, [player_1, player_2])
        expect(board.instance_variable_get(:@board)[9][3]).to eq(' B ')
      end
    end
  end
end
