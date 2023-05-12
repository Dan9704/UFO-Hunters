require 'gosu'
require_relative 'player'
require_relative 'flame'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'invader'
#page 75
class Chicken < Gosu::Window
    def initialize
        @window_width = 800
        @window_height = 600
        super(@window_width, @window_height, false)
        self.caption = "Chicken"
        @player = Player.new(self)
        #Set moving background
        @background_image = Gosu::Image.new("galaxy.png", tileable: true)  
        @background_y = 0
        @background_speed = 1.5
        #Set up enemies
        @invaders = []
        @invader_timer = 0
        @invader_interval = 100
        #Set up bullets
        @bullets = []
        #Set up explosion 
        @explosions = []

    end

    def update
        @player.move_right if button_down?(Gosu::KbRight)
        @player.move_left if button_down?(Gosu::KbLeft)
        @player.move
        @invaders.each { |invader| invader.move }
        #@flames.push Flame.new(self, 100, 100)
        @invader_timer += 1
        if @invader_timer >= @invader_interval
            @invaders.push Invader.new(self, 100, 100)
            @invader_timer = 0
        end
        #move the bullets
        @bullets.each do |bullet|
            bullet.move
        end
        #handle collision
        @invaders.dup.each do |invader|
            @bullets.dup.each do |bullet|
                distance = Gosu.distance(invader.x, invader.y, bullet.x, bullet.y)
                if distance < invader.radius + bullet.radius
                    @invaders.delete invader
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, invader.x, invader.y)
                end
            end
        end

        #moving background
        @background_y += @background_speed
        @background_y %= @background_image.height

        #delete explosions
        @explosions.dup.each do |explosion|
            @explosions.delete explosion if explosion.finished
        end

        #delte enemies and bullets
        @invaders.dup.each do |invader|
            if invader.y > @window_height + invader.radius
                @invaders.delete invader
            end
        end
        @bullets.dup.each do |bullet|
            @bullets.delete bullet unless bullet.onscreen?
        end
    end

    def draw
        @player.draw
        @background_image.draw(0, 0, 0)
        @invaders.each do |invader|
            invader.draw
        end
        #now draw the bullet
        @bullets.each do |bullet|
            bullet.draw
        end
        #handle conllision
        @explosions.each do |explosion|
            explosion.draw
        end
        #handle moving background 
        @background_image.draw(0, @background_y, 0, @window_width.to_f / @background_image.width, 1)
        @background_image.draw(0, @background_y - @background_image.height, 0, @window_width.to_f / @background_image.width, 1)
    end

    def button_down(id)
        if id == Gosu::KbSpace
            @bullets.push Bullet.new(self, @player.x + 37, @player.y + 25, @player.angle)
        end
    end
end

window = Chicken.new
window.show

