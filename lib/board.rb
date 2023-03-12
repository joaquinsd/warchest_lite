class Board
  def initialize(board_size)
    @board = Array.new(board_size+1) { Array.new(board_size+1)}
  end
  def fill_board
    #Here we'll set the column Headers
    @board[0] = ['   ', ' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ', ' 7 ', ' 8 ', ' 9 ']
    # And now we set row headers
    ('a'..'i').each_with_index do |row_header, index|
      @board[index + 1].fill(' . ')
      @board[index + 1][0] = " " + row_header + " "
    end
    # Now we'll set the all the control zones
    # first the available ones
    (0..9).each do |row|
      (0..9).each do |col|
        if (row == 4 && [2, 4, 7].include?(col)) || (row == 6 && [3, 6, 8].include?(col))
          @board[row][col] = " @ "
        end
      end
    end
  end
  def setup_control_points(player_1, player_2)
    # Now we set the player control coordinates
    @board[1][3] = " #{player_1.name[0]} "
    @board[1][7] = " #{player_1.name[0]} "
    @board[9][3] = " #{player_2.name[0]} "
    @board[9][7] = " #{player_2.name[0]} "
    player_1.control_zone = [[1,3], [1,7]]
    player_2.control_zone = [[9,3], [9,7]]
  end
  def display_board(player = nil)
    puts "======================================="
    @board.each do |row|
      puts row.join(' ')
    end
    unless player.nil?
      puts "================ #{player.name} ================"
      puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}"
      puts "Recruitment pieces: #{player.recruitment.group_by { |unit| unit.class }.transform_values(&:count).map { |klass, count| "#{klass.to_s.split('::').last} = #{count}" }.join(', ')}"
      puts "Discard Pile: #{player.discard_pile.group_by { |unit| unit.class }.transform_values(&:count).map { |klass, count| "#{klass.to_s.split('::').last} = #{count}" }.join(', ')}"
      puts ""
      puts "Control Tokens: #{player.control_tokens}"
    end
  end
  def place_unit(row, column, unit_name)
    @board[row][column] = "#{unit_name.slice(0..1)} "
  end
  def remove_unit(row, column, players)
    player_1, player_2 = players
    location = [row, column]
    @board[row][column] =
      if player_1.control_zone.include?(location)
        " #{player_1.name[0]} "
      elsif player_2.control_zone.include?(location)
        " #{player_2.name[0]} "
      else
        " . "
      end
  end
end