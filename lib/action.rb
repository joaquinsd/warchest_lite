class Action
  def initialize
  end
  def move(player, board, players, same_piece = nil )
    moved_piece = same_piece.nil? ? get_moved_piece(player) : same_piece
    if same_piece.nil?
      discarded_piece = get_piece(player, 'discard')
      discard_helper(player, discarded_piece)
    end
    destination_row, destination_col = get_destination_coordinates(moved_piece)
    board.remove_unit(moved_piece.row, moved_piece.column, players)
    board.place_unit(destination_row, destination_col, moved_piece.type)
    moved_piece.set_location(destination_row, destination_col)
    if moved_piece.type == 'Cavalry'
      puts 'You can attack now with the same unit'
      print 'Proceed?: (y/n)'
      proceed = gets.chomp
      until proceed == "y" || proceed == "n"
        puts 'Invalid choice, please try again!'
        print 'Proceed?: (y/n)'
        proceed = gets.chomp
      end
      self.attack(player, board, players, moved_piece) if proceed == 'y'
    end
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
  end
  def recruit(player)
    print "Piece to discard from hand to recruit the same kind: "
    discard_type = gets.chomp.capitalize
    if discard_type == 'Royal'
      print "Used Royal coin, select the piece you want to recruit: "
      recruit_type = gets.chomp.capitalize
      discard_helper(player, discard_type)
      recruiter_helper(player, recruit_type)
      puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
      return
    end
    discard_helper(player, discard_type)
    recruiter_helper(player, discard_type)
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
  end
  def place(player, board)
    piece_type = get_piece(player, 'place')
    hand_piece = player.hand.find { |chip| chip.type == piece_type}
    player.hand.delete(hand_piece)
    destination_row, destination_col = get_place_coordinates(player)
    board.place_unit(destination_row, destination_col, hand_piece.type)
    hand_piece.set_location(destination_row, destination_col)
    player.board_units.push(hand_piece)
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}"
  end
  def attack(player, board, players, same_piece = nil)
    attacking_piece = same_piece.nil? ? get_attacking_piece(player) : same_piece
    if same_piece.nil?
      discarded_piece = get_piece(player, 'discard')
      discard_helper(player, discarded_piece)
    end
    opposing_player = players.find { |p| p != player }
    target_row, target_column = get_attacking_coordinates(attacking_piece, opposing_player)
    attacked_piece = get_piece_from_board(player, target_row, target_column)
    board.remove_unit(target_row, target_column, players)
    opposing_player.board_units.delete(attacked_piece)
    if attacking_piece.type == 'Swordsman' || (attacking_piece.type == 'Berserker' && same_piece.nil?)
      puts 'You can act again now with the same unit'
      print 'Proceed? (y/n): '
      proceed = gets.chomp
      until proceed == "y" || proceed == "n"
        puts 'Invalid choice, please try again!'
        print 'Proceed? (y/n): '
        proceed = gets.chomp
      end
      if proceed == 'y'
        if attacking_piece.type == 'Swordsman'
          self.move(player, board, players, attacking_piece)
        else
          self.attack(player, board, players, attacking_piece)
        end
      end
    end
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
  end
  def control(player, players)
    piece_type = get_piece(player, 'control')
    control_row, control_column = get_control_coordinates(player)
    player.board_units
    discard_helper(player, piece_type)
    player.control_zone.push([control_row, control_column])
    player.control_tokens -= 1
    opposing_player = players.find { |p| p != player }
    opposing_player.control_zone.delete([control_row, control_column])
    opposing_player.control_tokens += 1
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
  end
  def initiative(player, players)
    piece_type = get_piece(player, 'initiative')
    discard_helper(player, piece_type)
    get_initiative(player, players)
    puts "Hand: #{player.hand.map{|e| e.type}.join(', ')}" if player.hand.any?
  end

  private

  def get_attacking_piece(player)
    loop do
      print "Attack from position (row, col): "
      origin_row, origin_col = gets.chomp.split
      origin_row = letter_coordinates(origin_row)
      origin_col = origin_col.to_i
      attacking_piece = get_piece_from_board(player, origin_row, origin_col)
      unless attacking_piece
        puts "No attacking piece on that position, try again"
        next
      end
      unless validate_in_hand(attacking_piece.type, player.hand)
        puts "No piece of that kind on your hand, please try again!"
        next
      end
      return attacking_piece
    end
  end
  def get_initiative(player, players)
    player.initiative = true
    opposing_player = players.find { |p| p != player }
    opposing_player.initiative = false
  end
  def get_moved_piece(player)
    loop do
      print "From position (row, col): "
      origin_row, origin_col = gets.chomp.split
      origin_row = letter_coordinates(origin_row)
      origin_col = origin_col.to_i
      moved_piece = get_piece_from_board(player, origin_row, origin_col)
      unless moved_piece
        puts "No piece on that position, try again"
        next
      end
      unless validate_in_hand(moved_piece.type, player.hand)
        puts "No piece of that kind on your hand, please try again!"
        next
      end
      return moved_piece
    end
  end
  def get_piece(player, action)
    loop do
      if action == 'place'
        message = "Piece to place from Hand: "
      elsif action == 'discard'
        message = "Select a piece of the same type in your hand: "
      else
        message = 'Piece to discard from hand: '
      end
      print message
      piece_type = gets.chomp.capitalize
      if player.hand.any?{|piece| piece.type == piece_type}
        return piece_type
      else
        puts "You don't have that piece, please try again!"
      end
    end
  end
  def get_attacking_coordinates(attacking_piece, player)
    loop do
      print "To position (row, col): "
      target_row, target_col = gets.chomp.split
      target_row = letter_coordinates(target_row)
      target_col = target_col.to_i
      unless attacking_piece.validate_attack(target_row, target_col)
        puts 'Invalid attack reach, please try again!'
        next
      end
      unless player.board_units.any?{|piece| piece.row == target_row && piece.column == target_col}
        puts 'No enemy unit on that location, please try again!'
        next
      end
      return [target_row, target_col]
    end
  end
  def get_destination_coordinates(moved_piece)
    loop do
      print "To position (row, col): "
      destination_row, destination_col = gets.chomp.split
      destination_row = letter_coordinates(destination_row)
      destination_col = destination_col.to_i
      unless moved_piece.validate_movement(destination_row, destination_col)
        puts 'Invalid movement range, please try again!'
        next
      end
      return [destination_row, destination_col]
    end
  end
  def get_place_coordinates(player)
    loop do
      print "Position to place(row, col): "
      destination_row, destination_col = gets.chomp.split
      destination_row = letter_coordinates(destination_row)
      destination_col = destination_col.to_i
      unless valid_place_destination(player, destination_row, destination_col)
        puts "You can't place a unit away from your control zones!"
        puts 'Please try again!'
        next
      end
      return [destination_row, destination_col]
    end
  end
  def get_control_coordinates(player)
    loop do
      print "Position to control (row, col): "
      destination_row, destination_col = gets.chomp.split
      destination_row = letter_coordinates(destination_row)
      destination_col = destination_col.to_i
      if player.control_zone.include?([destination_row, destination_col])
        puts "Can't control zones already controlled by you!"
        puts 'Please try again!'
        next
      end
      unless valid_unit_location(player, destination_row, destination_col)
        puts "You don't have units on that location!"
        puts 'Please try again!'
        next
      end
      unless valid_control_destination(destination_row, destination_col)
        puts "Invalid control coordinate!"
        puts 'Please try again!'
        next
      end
      return [destination_row, destination_col]
    end
  end
  def recruiter_helper(player, piece_type)
    recruited_chip = player.recruitment.find{ |chip| chip.type == piece_type}
    player.recruitment.delete(recruited_chip)
    player.bag.push(recruited_chip)
  end
  def discard_helper(player, piece_type)
    hand_chip = player.hand.find { |chip| chip.type == piece_type}
    player.hand.delete(hand_chip)
    player.discard_pile.push(hand_chip)
  end
  def letter_coordinates(letter)
    letter.ord - 'a'.ord + 1
  end
  def get_piece_from_board(player, row, column)
    player.board_units.select {|unit| unit.row == row && unit.column == column}.first
  end
  def validate_in_hand(unit_type, hand)
    hand.any? { |piece| piece.type == unit_type }
  end
  def valid_place_destination(player, row, column)
    player.control_zone.map do |control_zone|
      control_row = control_zone.first
      control_column = control_zone.last
      distance = (row - control_row).abs + (column - control_column).abs
      return true if distance == 1
    end
    false
  end
  def valid_control_destination(row, column)
    valid_control_coordinates = [[1,3], [1,7], [4,2], [4,4], [4,7], [6,3], [6,6], [6,8], [9,3], [9,7]]
    valid_control_coordinates.include?([row,column])
  end
  def valid_unit_location(player, row, column)
    player.board_units.any?{|unit| unit.row == row && unit.column == column}
  end
end