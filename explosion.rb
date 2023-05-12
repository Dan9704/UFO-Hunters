class Explosion
    attr_reader :finished
    def initialize(window, x, y)
        @x = x
        @y = y 
        @radius = 30
        @image = Gosu::Image.load_tiles('explosion2.png', 100, 100)
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
