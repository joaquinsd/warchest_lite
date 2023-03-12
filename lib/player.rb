class Player
  attr_accessor :name, :bag, :hand, :recruitment, :control_zone, :discard_pile, :control_tokens, :board_units, :initiative

  def initialize(name)
    @name = name
    @bag = []
    @hand = []
    @recruitment = []
    @control_zone = []
    @discard_pile = []
    @board_units = []
    @control_tokens = 4
    @initiative = false
  end
end