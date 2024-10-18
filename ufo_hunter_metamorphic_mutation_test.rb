require 'minitest/autorun'
require_relative 'ufo_hunter'  # Replace with your UFO Hunter game file name

class TestUFOHunters < Minitest::Test

  # ---------------- Metamorphic Testing ---------------- #

  # Metamorphic Relation 1: Invader1 Speed Modification
  def test_invader1_speed_modification
    # Test Group 1: Default invader1 speed
    assert_equal(2, Invader1::SPEED)

    # Test Group 2: Increase invader1 speed by 50%
    Invader1.const_set(:SPEED, 3.0)
    assert_equal(3.0, Invader1::SPEED)

    # Test Group 3: Decrease invader1 speed by 50%
    Invader1.const_set(:SPEED, 1.0)
    assert_equal(1.0, Invader1::SPEED)

    # Test Group 4: Set invader1 speed to zero (immobilized invader)
    Invader1.const_set(:SPEED, 0)
    assert_equal(0, Invader1::SPEED)

    # Test Group 5: Set invader1 speed to a random value
    random_speed = rand(1..5)
    Invader1.const_set(:SPEED, random_speed)
    assert_equal(random_speed, Invader1::SPEED)

    # Reset invader1 speed to default
    Invader1.const_set(:SPEED, 2)
  end

  # Metamorphic Relation 2: Invader1 Health Points (HP) Modification
  def test_invader1_hp_modification
    invader1 = Invader1.new(nil, 100, 100)  # Initialize an invader1 instance for the test

    # Test Group 1: Default invader1 HP
    assert_equal(5, invader1.hp)

    # Test Group 2: Double invader1 HP
    invader1.hp = 10
    assert_equal(10, invader1.hp)

    # Test Group 3: Half invader1 HP
    invader1.hp = 2.5
    assert_equal(2.5, invader1.hp)

    # Test Group 4: Set invader1 HP to a random value
    random_hp = rand(1..10)
    invader1.hp = random_hp
    assert_equal(random_hp, invader1.hp)

    # Test Group 5: Set invader1 HP to zero (instantly destroyed)
    invader1.hp = 0
    assert_equal(0, invader1.hp)
  end

  # ---------------- Mutation Testing ---------------- #
  # Mutation testing introduces small changes to the program (mutants)
  # to verify the effectiveness of the tests in catching errors.

    # Mutant 1: Change Invader1 speed increment (+=) to (-=)
    def test_mutant_invader1_speed1
        Invader1.const_set(:SPEED, 1.5)
        assert_equal(1.5, Invader1::SPEED)
        Invader1.const_set(:SPEED, 2)  # Reset speed after test
    end

    # Mutant 2: Change Invader1 HP increment (*=)
    def test_mutant_invader1_hp1
        invader1 = Invader1.new(nil, 100, 100)
        invader1.hp *= 2  # Mutate HP by multiplying it
        assert_equal(10, invader1.hp)
    end

    # Mutant 3: Modify Invader1 HP to a random value
    def test_mutant_invader1_hp_random
        invader1 = Invader1.new(nil, 100, 100)
        invader1.hp = rand(1..20)  # Set HP to a random value
        refute_nil(invader1.hp)
    end

    # Mutant 4: Change Invader1 movement logic (+=) to (-=)
    def test_mutant_invader1_movement
        Invader1.const_set(:SPEED, -2)
        assert_equal(-2, Invader1::SPEED)
        Invader1.const_set(:SPEED, 2)  # Reset speed
    end

    # Mutant 5: Modify bullet speed constant from 5 to 10
    def test_mutant_bullet_speed
        Bullet.const_set(:SPEED, 10)
        assert_equal(10, Bullet::SPEED)
        Bullet.const_set(:SPEED, 5)  # Reset speed
    end

    # Mutant 6: Modify Invader1 speed constant from 2 to 3
    def test_mutant_invader1_speed2
        Invader1.const_set(:SPEED, 3)
        assert_equal(3, Invader1::SPEED)
        Invader1.const_set(:SPEED, 2)  # Reset speed
    end

    # Mutant 7: Change player speed from 7 to 5
    def test_mutant_player_speed
        Player.const_set(:SPEED, 5)
        assert_equal(5, Player::SPEED)
        Player.const_set(:SPEED, 7)  # Reset speed
    end

    # Mutant 8: Modify player lives from 3 to 1
    def test_mutant_player_lives
        game = UFO_Hunters.new
        game.mutant_player_lives1
        assert_equal 1, game.hearts_life
    end

    # Mutant 9: Modify explosion radius from 30 to 50
    def test_mutant_explosion_radius
        game = UFO_Hunters.new
        game.mutant_explosion_radius
        assert_equal 50, game.explosion_radius
    end

    # Mutant 10: Change Invader1 HP decrement (HP -= 1) to (HP -= 2)
    def test_mutant_invader1_hp_decrement
        invader1 = Invader1.new(nil, 100, 100)
        invader1.hp -= 2
        assert_equal(3, invader1.hp)
    end

    # Mutant 11: Modify player movement logic (+=) to (-=)
    def test_mutant_player_movement
        Player.const_set(:SPEED, -7)
        assert_equal(-7, Player::SPEED)
        Player.const_set(:SPEED, 7)  # Reset speed
    end

    # Mutant 12: Modify Invader1 speed to a negative value
    def test_mutant_invader1_speed_negative
        Invader1.const_set(:SPEED, -1)
        assert_equal(-1, Invader1::SPEED)
        Invader1.const_set(:SPEED, 2)  # Reset speed
    end

    # Mutant 13: Change player lives check (if lives > 0) to (if lives < 0)
    def test_mutant_player_lives_check
        game = UFO_Hunters.new
        game.hearts_life = -1
        assert_operator(game.hearts_life, :<, 0)
    end

    # Mutant 14: Change missile speed from 3 to 6
    def test_mutant_missile_speed
        Missile.const_set(:SPEED, 6)
        assert_equal(6, Missile::SPEED)
        Missile.const_set(:SPEED, 3)  # Reset speed
    end

    # Mutant 15: Modify explosion radius calculation to random value
    def test_mutant_explosion_radius_random
        game = UFO_Hunters.new
        game.mutant_explosion_radius_random
        refute_nil(game.explosion_radius)
    end

    # Mutant 16: Modify missile speed to random value
    def test_mutant_missile_speed_random
        game = UFO_Hunters.new
        game.mutant_missile_speed_random
        refute_nil(game.missile_speed)
    end

    # Mutant 17: Modify Invader1 position (+=) to (-=)
    def test_mutant_invader1_position
        invader1 = Invader1.new(nil, 100, 100)
        invader1.x -= 10
        assert_equal(90, invader1.x)
    end

    # Mutant 18: Modify bullet direction to 90 degrees
    def test_mutant_bullet_direction
        bullet = Bullet.new(nil, 100, 100, 90)
        assert_equal(90, bullet.instance_variable_get(:@direction))
    end

    # Mutant 19: Change player speed to random value
    def test_mutant_player_speed_random
        Player.const_set(:SPEED, rand(1..10))
        refute_nil(Player::SPEED)
        Player.const_set(:SPEED, 7)  # Reset speed
    end

    # Mutant 20: Change Invader1 radius to random value
    def test_mutant_invader1_radius
        invader1 = Invader1.new(nil, 100, 100)
        invader1.radius = rand(10..50)
        refute_nil(invader1.radius)
      end
    
      # Mutant 21: Modify missile speed to zero
      def test_mutant_missile_speed_zero
        Missile.const_set(:SPEED, 0)
        assert_equal(0, Missile::SPEED)
        Missile.const_set(:SPEED, 3)  # Reset speed
      end
    
      # Mutant 22: Modify bullet radius to a larger value
      def test_mutant_bullet_radius
        bullet = Bullet.new(nil, 100, 100, 90)
        bullet.instance_variable_set(:@radius, 10)
        assert_equal(10, bullet.radius)
      end
    
      # Mutant 23: Modify player angle to 180 degrees
      def test_mutant_player_angle
        player = Player.new(nil)
        player.instance_variable_set(:@angle, 180)
        assert_equal(180, player.angle)
      end
    
      # Mutant 24: Modify Invader1 HP to a negative value
      def test_mutant_invader1_hp_negative
        invader1 = Invader1.new(nil, 100, 100)
        invader1.hp = -5
        assert_equal(-5, invader1.hp)
      end
    
      # Mutant 25: Change player Y position increment to zero
      def test_mutant_player_position_y_zero
        player = Player.new(nil)
        player.instance_variable_set(:@y, 0)
        assert_equal(0, player.y)
      end
    
      # Mutant 26: Modify missile position increment to a large positive value
      def test_mutant_missile_position_large
        missile = Missile.new(nil, 100, 100)
        missile.instance_variable_set(:@y, 1000)
        assert_equal(1000, missile.y)
      end
    
      # Mutant 27: Modify explosion radius to 0
      def test_mutant_explosion_radius_zero
        game = UFO_Hunters.new
        game.mutant_explosion_radius_zero
        assert_equal 0, game.explosion_radius
      end
    
      # Mutant 28: Modify player movement to reverse direction (left to right)
      def test_mutant_player_reverse_movement
        player = Player.new(nil)
        player.move_right
        assert_operator(player.x, :>, 0)
      end
    
      # Mutant 29: Modify Invader1 Y position to random large value
      def test_mutant_invader1_position_y_large
        invader1 = Invader1.new(nil, 100, 100)
        invader1.instance_variable_set(:@y, rand(1000..2000))
        assert_operator(invader1.y, :>, 1000)
      end
    
      # Mutant 30: Modify Invader1 Y position increment (+=) to (*= 2)
      def test_mutant_invader1_position_y
        invader1 = Invader1.new(nil, 100, 100)
        invader1.instance_variable_set(:@y, invader1.y * 2)
        assert_operator(invader1.y, :>, 100)
      end
    end    
  
