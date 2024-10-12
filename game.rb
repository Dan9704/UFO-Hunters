require 'gosu'

################################################
############# Classes declaration ##############
################################################

# --------------------------------------------------------------------------------------------------
# -------------------------------------- HEART -------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Heart
    SPEED = 2
    attr_reader :x, :y, :angle, :radius
    def initialize(window, x, y)
      @radius = 25
      @image = Gosu::Image.new("image/heart_shield.png") # Replace with your single image file
      @window = window
      @x = x
      @y = y
    end
    # ----------------------------------------------
    def draw
      @image.draw(@x, @y, 0)
    end
    # ----------------------------------------------
    def move
      @y += SPEED
      if @y > @window.height
        @window.missiles.delete(self)
      end
    end
    # ----------------------------------------------
    def y
      @y
    end
  end
# --------------------------------------------------------------------------------------------------
# -------------------------------------- MISSILE ---------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Missile
    SPEED = 3
    attr_reader :x, :y, :angle, :radius
    def initialize(window, x, y)
        @radius = 30
      @animation_frames = [] # Initialize the array to hold animation frames
      5.times do |i|
        frame = Gosu::Image.new("missile/missile_#{i + 1}.png") #21x75
        @animation_frames.push(frame)
      end
      @window = window
      @x = x
      @y = y
      @current_frame = 0 # Track the current frame of the animation
    end
    # ----------------------------------------------
    def draw
      @animation_frames[@current_frame].draw(@x, @y, 0)
      @current_frame = (@current_frame + 1) % @animation_frames.length # Cycle through frames
    end
    # ----------------------------------------------
    def move
      @y += SPEED
      if @y > @window.height
        @window.missiles.delete(self)
      end
    end
    # ----------------------------------------------
    def y
        @y
    end
  end
# ---------------------------------------------------------------------------------------------------
# -------------------------------------- INVADER ----------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Invader
    SPEED = 2.5
    attr_reader :x, :y, :radius
    def initialize(window, x, y)
        @radius = 20
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0
        @image = Gosu::Image.load_tiles('image/enemy4244.png', 42, 44)
        @image_index = 0
    end

    def draw
        if @image_index < @image.count
            @image[@image_index].draw(@x - @radius, @y - @radius, 1)
            @image_index += 1
        else
            @image_index = 0
        end  
    end

    def move
        @y += SPEED
    end
end
# ---------------------------------------------------------------------------------------------------
# -------------------------------------- INVADER1 ----------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Invader1
    SPEED = 2
    attr_accessor :x, :y, :radius, :hp
    def initialize(window, x, y)
        @radius = 40
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0
        @image = Gosu::Image.new('image/boss.png')
        @hp = 5
    end

    def draw
        @image.draw(@x - @radius, @y - @radius, 1)
    end

    def move
        @y += SPEED
    end
end
# --------------------------------------------------------------------------------------------------
# -------------------------------------- EXPLOSION ----------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Explosion
    attr_reader :finished
    def initialize(window, x, y)
        @x = x
        @y = y 
        @radius = 30
        @image = Gosu::Image.load_tiles('image/explosion2.png', 100, 100)
        @finished = false
        @image_index = 0 
    end

    def draw
        if @image_index < @image.count
            @image[@image_index].draw(@x - @radius, @y - @radius, 2)
            @image_index += 1
        else
            @finished = true
        end
    end
end
# --------------------------------------------------------------------------------------------------
# -------------------------------------- BULLET ----------------------------------------------------
# --------------------------------------------------------------------------------------------------
class Bullet
    SPEED = 5
    attr_reader :x, :y, :radius
    def initialize(window, x, y, angle)
        @x = x
        @y = y
        @direction = angle
        @image = Gosu::Image.new('image/bullet.png')
        @radius = 3
        @window = window
    end

    def move
        @x += Gosu.offset_x(@direction, SPEED)
        @y += Gosu.offset_y(@direction, SPEED)
    end

    def draw
        @image.draw(@x - @radius, @y - @radius, 1)
    end
    def onscreen?
        right = @window.width + @radius
        left = -@radius
        top = -@radius
        bottom = @window.height + @radius
        @x > left and @x < right and @y > top and @y < bottom
    end
end
# --------------------------------------------------------------------------------------------------
# -------------------------------------- PLAYER ----------------------------------------------------
# --------------------------------------------------------------------------------------------------
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
      @radius = 30
      @image = Gosu::Image.new('image/ship.png')
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

# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------

################################################
################## Game Main ###################
################################################

class UFO_Hunters < Gosu::Window
    INVADER_FREQUENCY = 5
    def initialize
        @window_width = 800
        @window_height = 600
        super(@window_width, @window_height, false)
        self.caption = "UFO Hunters"

        #Include images into game
        @start_image = Gosu::Image.new("image/open_screen.png", tileable: true)  
        @background_image = Gosu::Image.new("image/galaxy.png", tileable: true) 
        @missile_start = Gosu::Image.new("image/missile.png", tileable: true) 
        @instructions_image = Gosu::Image.new("image/Instruction.png", tileable: true)
        @credits_image = Gosu::Image.new("image/credits.png", tileable: true)
        @plot_image = Gosu::Image.new("image/plot.png", tileable: true)
        @scene = :start
        @background_y = 0
        @background_speed = 1.5
        @info_font = Gosu::Font.new(20)

        # ----------------------------------------------
        # Animation in start screen
        @hover_start = false
        @hover_plot = false
        @hover_instructions = false
        @hover_credits = false

        # ----------------------------------------------
        #Include sound into game
        @background_sound = Gosu::Song.new("sound/background_sound.mp3")
        @background_sound.volume = 0.5
        @background_sound.play(true)
        @explosion_sound = Gosu::Sample.new("sound/explosion.mp3")
        @shooting_sound = Gosu::Sample.new("sound/shoot.mp3")
        @hover_sound = Gosu::Sample.new("sound/hover_sound.mp3")
        @bonus_life = Gosu::Sample.new("sound/bonus_life.mp3")
    end
    # ----------------------------------------------
    def initialize_game
        @player = Player.new(self)
        @invaders = []
        @invaders1 = []
        @bullets = []
        @explosions = []
        @missiles = []
        @hearts = []
        @scene = :game 
        @background_y = 0
        @background_speed = 1.5
        @invader_timer = 0
        @invader_interval = 100
        @background_image = Gosu::Image.new("image/galaxy.png", tileable: true)  
        @heart_image = Gosu::Image.new("image/heart.png")
        @hearts_life = 3
        @score = 0
        @score_font = Gosu::Font.new(30)
        @score_end_font = Gosu::Font.new(30)
    end
    # ----------------------------------------------
    def initialize_end(status)
        @end_sucess_image = Gosu::Image.new("image/end_sucess.png")
        @end_fail_image = Gosu::Image.new("image/end_fail.png")
        case status
        when :hit_by_enemy
        end
        @scene = :end
        @score_end_font = Gosu::Font.new(75) 
    end 
    def draw_end
        if @score > 100
            @end_sucess_image.draw(0, 0, 0)
        else
            @end_fail_image.draw(0, 0, 0)
        end
        @score_end_font.draw(@score, 385, 228, 1, 1, 1, Gosu::Color::WHITE)
    end
    # ----------------------------------------------
    def draw
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        when :end
            draw_end
        end
    end
    # ----------------------------------------------
    def draw_start
        # -------- Make the background image moving ---------
        @background_image.draw(0, @background_y, 0, @window_width.to_f / @background_image.width, 1)
        @background_image.draw(0, @background_y - @background_image.height, 0, @window_width.to_f / @background_image.width, 1)
        @start_image.draw(0, 0, 0)

        # -------- Draw missile in the start screen with hover animation ---------
        if @hover_start
            @missile_start.draw(15,306,0)
        end

        if @hover_plot
            @missile_start.draw(15,355,0)
        end

        if @hover_instructions
            @missile_start.draw(15,400,0)
        end

        if @hover_credits
            @missile_start.draw(15,450,0)
        end

        # -------- Handle plot and instructions and credits window ---------
        if @plot_visible
            @plot_image.draw(0, 0, 0)
        end

        if @instructions_visible 
            @instructions_image.draw(0, 0, 0)
        end

        if @credits_visible
            @credits_image.draw(0, 0, 0)
        end
    end
    # ----------------------------------------------
    def draw_game
        @score_font.draw(@score, 30, 40, 1, 1, 1, Gosu::Color::WHITE)
        @player.draw
        # -------- Draw the invaders in the screen ---------
        @invaders.each do |invader|
            invader.draw
        end
        # -------- Draw the invaders1 in the screen ---------
        @invaders1.each do |invader1|
            invader1.draw
        end
        # -------- Draw the bullets in the screen ---------
        @bullets.each do |bullet|
            bullet.draw
        end
        # -------- Draw the explosion in the screen ---------
        @explosions.each do |explosion|
            explosion.draw
        end
        # -------- Make the backgr movin in Game screen ---------
        @background_image.draw(0, @background_y, 0, @window_width.to_f / @background_image.width, 1)
        @background_image.draw(0, @background_y - @background_image.height, 0, @window_width.to_f / @background_image.width, 1)
        # -------- Draw remaining hearts(lives left) ---------
        heart_spacing = 10
        heart_start_x = self.width - (@heart_image.width + heart_spacing) * @hearts_life
        heart_y = 20

        @hearts_life.times do |i|
            heart_x = heart_start_x + i * (@heart_image.width + heart_spacing)
            @heart_image.draw(heart_x, heart_y, 0)
        end
        # -------- Draw the missiles falling down ---------
        @missiles.each do |missile|
            missile.draw
        end
        # -------- Draw the hearts falling down ---------
        @hearts.each do |heart|
            heart.draw
        end
    end
    # ----------------------------------------------
    def update
        case @scene 
        when :start
            update_start
        when :game
            update_game
        end
    end
    # ----------------------------------------------
    def button_down(id)
        case @scene
        when :start
            button_down_start(id)
        when :game
            button_down_game(id)
        when :end
            button_down_end(id)
        end
    end
    # ----------------------------------------------
    def button_down_start(id)
        if @hover_start
            initialize_game
        end
        # -------- Make Instructions window appear ---------
        if @hover_instructions
            @instructions_visible = true
        end
        if @hover_return
            @instructions_visible = false
        end
        # -------- Make Credit window appear ---------
        if @hover_credits
            @credits_visible = true
        end
        # -------- Return to home screen ---------
        if @hover_return
            @credits_visible = false
        end
        # -------- Make Plot window appear ---------
        if @hover_plot
            @plot_visible = true
        end
        # -------- Return to home screen ---------
        if @hover_return
            @plot_visible = false
        end
    end
    # ----------------------------------------------
    def button_down_game(id)
        if id == Gosu::KbSpace
            @bullets.push Bullet.new(self, @player.x + 37, @player.y + 25, @player.angle)
            @shooting_sound.play
        end
    end
    # ----------------------------------------------
    def update_start
        # -------- Animation for background ---------
        @background_y += @background_speed
        @background_y %= @background_image.height
        # -------- Indicate START button ---------
        # 85, 340   187, 361
        if ((mouse_x > 85 and mouse_x < 187) and (mouse_y > 340 and mouse_y < 361))
            @hover_start = true
          else
            @hover_start = false
        end
        # -------- Indicate PLOT button ---------
        # 85, 388    166, 408
        if ((mouse_x > 85 and mouse_x < 166) and (mouse_y > 388 and mouse_y < 408))
            @hover_plot = true
          else
            @hover_plot = false
        end
        # -------- Indicate INSTRUCTIONS button ---------
        # 85, 434    317, 456
        if ((mouse_x > 85 and mouse_x < 317) and (mouse_y > 434 and mouse_y < 456))
            @hover_instructions = true
          else
            @hover_instructions = false
        end
        # -------- Indicate CREDITS button ---------
        # 85, 482    218, 503
        if ((mouse_x > 85 and mouse_x < 218) and (mouse_y > 482 and mouse_y < 503))
            @hover_credits = true
          else
            @hover_credits = false
        end
        # -------- Indicate RETURN button ---------
        # 34,33      69, 90
        if ((mouse_x > 34 and mouse_x < 69) and (mouse_y > 33 and mouse_y < 90))
            @hover_return = true
          else
            @hover_return = false
        end
    end
	# ----------------------------------------------
    def update_game
        # ------------ Player movement --------------
        @player.move_right if button_down?(Gosu::KbRight)
        @player.move_left if button_down?(Gosu::KbLeft)
        @player.move
        # ------------ Invader movement --------------
        @invaders.each { |invader| invader.move }
        @invader_timer += 1
        if @invader_timer >= @invader_interval
            @invaders.push Invader.new(self, 100, 100)
            @invader_timer = 0
            @invader_interval -= 1 if @invader_interval > 10 # Decrease the interval over time
        end
        # ------------ Invader1 movement --------------
        @invaders1.each { |invader1| invader1.move }
        @invader_timer += 0.3
        if @invader_timer >= @invader_interval
            @invaders1.push Invader1.new(self, 100, 100)
            @invader_timer = 0
            @invader_interval -= 1 if @invader_interval > 10 # Decrease the interval over time
        end
        # ------------ Bullet movement --------------
        @bullets.each do |bullet|
            bullet.move
        end
        # -------- Collision between INVADER & BULLET ---------
        @invaders.dup.each do |invader|
            @bullets.dup.each do |bullet|
                distance = Gosu.distance(invader.x, invader.y, bullet.x, bullet.y)
                if distance < invader.radius + bullet.radius
                    @invaders.delete invader
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, invader.x, invader.y)
                    @explosion_sound.play
                    @score += 1
                    # -----------------------------------------------------------------------------
                    # Create HEART & MISSILE dropping from the exploded invader's position randomly
                    random_number = rand
                    if random_number < 0.5
                    missile = Missile.new(self, invader.x, invader.y)
                    @missiles.push(missile)
                    elsif random_number < 0.85
                    heart = Heart.new(self, invader.x, invader.y)
                    @hearts.push(heart)
                    end
                end
            end
        end

        # -------- Collision between INVADER1 & BULLET ---------
        @invaders1.dup.each do |invader1|
            @bullets.dup.each do |bullet|
              distance = Gosu.distance(invader1.x, invader1.y, bullet.x, bullet.y)
              if distance < invader1.radius + bullet.radius
                invader1.hp -= 1 # Add a hits counter to the invader
                
                if invader1.hp == 0
                  @invaders1.delete(invader1)
                  @score += 5
                end
           
                @bullets.delete(bullet)
                @explosions.push(Explosion.new(self, invader1.x, invader1.y))
                @explosion_sound.play
              end
            end
          end          
        # --------- Background moving ----------
        @background_y += @background_speed
        @background_y %= @background_image.height
        # ----------- Missile moving down -----------
        @missiles.each do |missile|
            missile.move
            @missiles.delete(missile) if missile.y > @window_height
        end
        # ----------- Heart moving down -----------
        @hearts.each do |heart|
            heart.move
            @hearts.delete(heart) if heart.y > @window_height
        end
        # -------- Collision between INVADER & PLAYER ---------
        @invaders.dup.each do |invader|
            distance = Gosu.distance(invader.x, invader.y, @player.x, @player.y)
            if distance < invader.radius + @player.radius
                @invaders.delete(invader)
                @explosions.push Explosion.new(self, invader.x, invader.y)
                @explosion_sound.play
                # ----------------------------------------------
                # Reduce the number of hearts
                @hearts_life -= 1
                # ----------------------------------------------
                # End screen indication
                if @hearts_life.zero?
                    # Player has lost all hearts, end the game
                    @scene = :end
                    initialize_end(:hit_by_enemy)
                else
                    # Create a new player instance
                    @player = Player.new(self)
                end
            end
        end
        # -------- Collision between INVADER1 & PLAYER ---------
        @invaders1.dup.each do |invader1|
            distance = Gosu.distance(invader1.x, invader1.y, @player.x, @player.y)
            if distance < invader1.radius + @player.radius
                @invaders1.delete(invader1)
                @explosions.push Explosion.new(self, invader1.x, invader1.y)
                @explosion_sound.play
                # ----------------------------------------------
                # Reduce the number of hearts
                @hearts_life -= 2
                # ----------------------------------------------
                # End screen indication
                if @hearts_life.zero?
                    # Player has lost all hearts, end the game
                    @scene = :end
                    initialize_end(:hit_by_enemy)
                else
                    # Create a new player instance
                    @player = Player.new(self)
                end
            end
        end

        # -------- Collision between MISSILE & PLAYER ---------
        @missiles.dup.each do |missile|
            distance = Gosu.distance(missile.x, missile.y, @player.x, @player.y)
            if distance < missile.radius + @player.radius
                @missiles.delete(missile)
                @explosions.push Explosion.new(self, missile.x, missile.y)
                @explosion_sound.play
        
                # Reduce the number of hearts
                @hearts_life -= 1
        
                if @hearts_life.zero?
                    # Player has lost all hearts, end the game
                    @scene = :end
                    initialize_end(:hit_by_enemy)
                else
                    # Create a new player instance
                    @player = Player.new(self)
                end
            end
        end

        # -------- Collision between HEART & PLAYER ---------
        @hearts.dup.each do |heart|
            distance = Gosu.distance(heart.x, heart.y, @player.x, @player.y)
            if distance < heart.radius + @player.radius
                @hearts.delete(heart)
                @bonus_life.play
                @hearts_life += 1
            end
        end
    end
        # ----------------------------------------------
        def missiles
            @missiles
        end
        # ----------------------------------------------
        def hearts
            @hearts
        end

        def button_down_end(id) 
            if id == Gosu::KbP
                initialize
            elsif id == Gosu::KbQ
                close
            end
        end
end

window = UFO_Hunters.new
window.show

