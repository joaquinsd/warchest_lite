require_relative 'game'
# start game
puts "Welcome to Warchest!"
print "Start game? (y/n):"
start = gets.chomp
until start == "y" || start == "n"
  puts 'Invalid choice, please try again!'
  print "Start game? (y/n):"
  start = gets.chomp
end
start == "y" ? nil : abort("Ok bye!")
puts "Enter first player name"
first_player_name = gets.chomp
puts "Enter second player name"
second_player_name = gets.chomp
player_1 = Player.new(first_player_name)
player_2 = Player.new(second_player_name)
game = Game.new(player_1, player_2)
game.setup_game
game.start_game