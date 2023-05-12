class Flame
    def initialize(window, x, y)
        @x = x
        @y = y
        @radius = 30
        @image = Gosu::Image.load_tiles('enemy4244.png', 42, 44)
        @image_index = 0
        #@finished = false
    end

    def draw
        if @image_index < @image.count
            @image[@image_index].draw(@x - @radius, @y - @radius, 2)
            @image_index += 1
        else
            @image_index = 0
        end  
    end
end