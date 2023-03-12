module Unit
  class BasicUnit
    attr_accessor :owner, :type, :row, :column
    def initialize(owner)
      @owner = owner
      @type = set_type
    end

    def set_type
      self.class.to_s.gsub("Unit::", "")
    end

    def validate_movement(destination_row, destination_col)
      # Destination must be within the board
      return false unless destination_row.between?(1, 9) && destination_col.between?(1, 9)
      # Destination cannot be the same that the unit is now
      return false if destination_row == self.row && destination_col == self.column
      true
    end

    def validate_attack(target_row, target_column)
      # Target must be within the board
      return false unless target_row.between?(1, 9) && target_column.between?(1, 9)
      # Target cannot be the same that the unit is now
      return false if target_row == self.row && target_column == self.column
      true
    end

    def set_location(row, column)
      self.row = row
      self.column = column
    end

    def within_orthogonal_range(target_row, target_column, range)
      # Target/Destination must be within the unit's orthogonal attack/movement range
      distance = (target_row - self.row).abs + (target_column - self.column).abs
      distance <= range
    end

    def within_adjacent_range(target_row, target_column, range)
      # Target/Destination must be within the unit's adjacent attack/movement range
      horizontal_distance = (target_row - self.row).abs
      vertical_distance = (target_column - self.column).abs
      horizontal_distance <= range && vertical_distance <= range && (vertical_distance == 0 || horizontal_distance == 0 || vertical_distance == horizontal_distance)
    end
  end
  class Royal < BasicUnit
  end
  class Archer < BasicUnit
    def validate_movement(destination_row, destination_col)
      super && within_orthogonal_range(destination_row, destination_col, 1)
    end

    def validate_attack(target_row, target_column)
      super && within_adjacent_range(target_row, target_column, 2)
    end
  end
  class Berserker < BasicUnit
    def validate_movement(destination_row, destination_col)
      super && within_orthogonal_range(destination_row, destination_col, 1)
    end

    def validate_attack(target_row, target_column)
      super && within_adjacent_range(target_row, target_column, 1)
    end
  end
  class Cavalry < Berserker
  end
  class Crossbowman < BasicUnit
    def validate_movement(destination_row, destination_col)
      super && within_orthogonal_range(destination_row, destination_col, 1)
    end
    def is_straight_line(row, column)
      self.row == row || self.column == column
    end

    def validate_attack(target_row, target_column)
      super && within_adjacent_range(target_row, target_column, 2) && is_straight_line(target_row, target_column)
    end
  end
  class Knight < Berserker
  end
  class Lancer < BasicUnit
    def validate_movement(destination_row, destination_col)
      super && within_orthogonal_range(destination_row, destination_col, 2)
    end
    def validate_attack(target_row, target_column)
      super && within_adjacent_range(target_row, target_column, 1)
    end
  end
  class Mercenary < Berserker
  end
  class Swordsman < Berserker
  end
end