class Invader
    SPEED = 2
    attr_reader :x, :y, :radius
    def initialize(window, x, y)
        @radius = 20
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0
        @image = Gosu::Image.load_tiles('enemy4244.png', 42, 44)
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
