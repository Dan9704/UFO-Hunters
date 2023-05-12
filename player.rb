class Player
    SPEED = 7
    SHIP_WIDTH = 80
    SHIP_HEIGHT = 80
    VERTICAL_SPEED = 0.5
    attr_reader :x, :y, :angle, :radius
    def initialize(window)
      @x = 350
      @y = 480
      @angle = 0
      @image = Gosu::Image.new('ship.png')
      @direction = :up
    end
  
    def draw
      @image.draw(@x, @y, 1)
    end
  
    def move_right
      @x += SPEED
    end
  
    def move_left
      @x -= SPEED
    end
  
    def move
      if @direction == :up
        @y -= VERTICAL_SPEED
        if @y <= 467
          @direction = :down
        end
      elsif @direction == :down
        @y += VERTICAL_SPEED
        if @y + SHIP_HEIGHT >= 550
          @direction = :up
        end
      end
  
      if @x + SHIP_WIDTH < 800 && @x > 0
        # player can move
      elsif @x <= 0
        # player is at the leftmost position
        @x = 0
      elsif @x + SHIP_WIDTH >= 800
        # player is at the rightmost position
        @x = 800 - SHIP_WIDTH
      end
    end
  end
  
