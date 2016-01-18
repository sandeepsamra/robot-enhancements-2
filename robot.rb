class NotARobot
  def initialize
  end
end

class RobotError < StandardError
end

class Robot

  attr_accessor :position, :array, :items, :items_weight, :equipped_weapon, :health

  def initialize
    @health = 0
    @position = [0,0]
    @items = []
    @items_weight = 0
    @equipped_weapon = nil
  end

  def move_left
    position[0] -= 1
  end

  def move_right
    position[0] += 1
  end

  def move_up
    position[1] += 1
  end

  def move_down
    position[1] -= 1
  end

  def pick_up(item)
    if items_weight < 250
      @items_weight += item.weight
      @items << item
    end
    if item.kind_of? Weapon
      @equipped_weapon = item
    else
      return nil
    end
    if @health <= 80 && item.kind_of?(BoxOfBolts)
      item.feed(self) #why won't this work - see spec 12
    end
  end

  def wound
    @health -= 5
    if health <= 0
      health = 0
    end
  end

  def heal(number)
    @health += number
    if health > 100
      health = 100
    end
  end

  def attack(other_robot)
    @other_position = other_robot.position
    if @other_position == [0,1] || @other_position == [0,-1]
      other_robot.wound
    end
    if @other_position == [0,2] && @equipped_weapon.kind_of?(Grenade)
      other_robot.wound
      @equipped_weapon = nil
    end
  end

  def heal!(number)
    if health <= 0
      raise RobotError, "Your robot is dead!"
    else
      heal(number)
    end
  end

  def attack!(other_robot)
    if other_robot.kind_of? Robot
      attack(other_robot)
    else
      raise RobotError, "Your target is not a robot."
    end
  end

end



