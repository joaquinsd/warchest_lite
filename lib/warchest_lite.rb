require_relative 'unit.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'action.rb'

module WarchestLite
  class Error < StandardError; end
  # Your code goes here...
  class Game
    def initialize(player_1, player_2)
      @player_1 = player_1
      @player_2 = player_2
      @players = [@player_1, @player_2]
    end
    def create_board
      @game_board = Board.new(9)
      @game_board.fill_board
      @game_board.setup_control_points(@player_1, @player_2)
    end
    def start_game
      @players.shuffle!
      current_player = @players.first
      create_board
      round = 1
      turns_in_round = 2
      until @game_over
        puts "Round #{round}"
        puts "It's #{current_player.name}'s turn"
        refill_bag(current_player) if current_player.bag.length < 3
        fill_hand(current_player)
        @game_board.display_board(current_player)
        while current_player.hand.length > 0
          action = action_treemap(current_player)
          if action == 'forfeit'
            forfeit_game(current_player) && break
          end
          if game_won?(current_player)
            @winner = current_player
            @game_over = true
          end
        end
        turns_in_round -=1
        current_player = @players[(@players.index(current_player) + 1) % @players.length]
        if turns_in_round == 0
          round += 1
          turns_in_round = 2
          current_player = @players.select { |player| player.initiative }.first if @players.any? {|player| player.initiative}
          current_player.initiative = false
        end
      end
      puts "Congratulations #{@winner.name} you are the winner!!"
    end
    def action_treemap(player)
      loop do
        print 'Make an action (move/recruit/place/attack/control/initiative/forfeit): '
        action = gets.chomp.downcase
        case action
        when "move"
          Action.new.move(player, @game_board, @players)
          break
        when "recruit"
          Action.new.recruit(player)
          break
        when "place"
          Action.new.place(player, @game_board)
          break
        when "attack"
          Action.new.attack(player, @game_board, @players)
        when "control"
          Action.new.control(player, @players)
        when "initiative"
          if player.initiative == false
            Action.new.initiative(player, @players)
            break
          else
            puts "You already have the initiative, try something else!"
            break
          end
        when "forfeit"
          return action
        else
          puts 'Invalid action, please try again'
        end
      end
    end
    def setup_game
      puts "Distributing unit types and chips..."
      unit_types = {
        "Archer": 4,
        "Berserker": 4,
        "Cavalry": 4,
        "Crossbowman": 5,
        "Knight": 5,
        "Lancer": 4,
        "Mercenary": 5,
        "Swordsman":4
      }
      p1_types = randomize_unit_types(unit_types)
      p2_types = unit_types.reject{|key, _value| p1_types.has_key?(key)}
      distribute_player_chips(p1_types, @player_1)
      distribute_player_chips(p2_types, @player_2)
    end
    def fill_hand(player)
      current_chips = player.hand.size
      player.hand += player.bag.shuffle!.pop(3 - current_chips)
    end
    def refill_bag(player)
      player.bag.push(player.discard_pile).flatten
    end
    def distribute_player_chips(types, player)
      types.each do |type, quantity|
        2.times do
          klass = Unit.const_get(type)
          type_chip = klass.new(player)
          player.bag << type_chip
        end
        (quantity - 2).times do
          klass = Unit.const_get(type)
          type_chip = klass.new(player)
          player.recruitment << type_chip
        end
      end
      player.bag << Unit::Royal.new(player)
    end
    def randomize_unit_types (available_types)
      available_types.to_a.shuffle.shift(4).to_h
    end
    def game_won?(player)
      opposing_player = @players.find { |p| p != player }
      # If your opponent can't place units and has none on board you win
      return true if (opposing_player.board_units.empty? && opposing_player.control_zone.empty?)

      # If your opponent has no units left for anything, you win
      return true if (opposing_player.recruitment.empty? && opposing_player.bag.empty? &&
        opposing_player.hand.empty? && opposing_player.board_units.empty? &&
        opposing_player.discard_pile.empty?)

      # If you place all your control tokens you win
      # This is equivalent to checking if player.control_zone.size == 6
      return true if player.control_tokens == 0
      false
    end
    def forfeit_game(player)
      @game_over = true
      @winner = @players.find { |p| p != player }
    end
  end
end

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
game = WarchestLite::Game.new(player_1, player_2)
game.setup_game
game.start_game

