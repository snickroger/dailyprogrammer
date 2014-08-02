require 'bundler/setup'

require 'chunky_png'

class Ant
	attr_accessor :location
	DIRECTIONS = [:north, :east, :south, :west]
	
	def direction
		return DIRECTIONS[@direction]
	end
	
	def initialize
		@direction = 0
		@location = Point.new(0,0)
	end
	
	def turn_cw
		@direction = (@direction + 1) % 4
	end
	
	def turn_ccw
		@direction = (@direction - 1) % 4
	end
	
	def move
		case direction()
			when :north
				@location = Point.new(@location.x, @location.y - 1)
			when :east
				@location = Point.new(@location.x - 1, @location.y)
			when :south
				@location = Point.new(@location.x, @location.y + 1)
			else
				@location = Point.new(@location.x + 1, @location.y)
		end
	end
end

class Point
	attr_accessor :x, :y
	def initialize(x,y)
		@x, @y = x,y
	end
	
	def ==(a)
		return self.x == a.x && self.y == a.y
	end
	
	def eql?(a)
		return self == a
	end
	
	def hash
		return [@x, @y].hash
	end
end

print "Enter turning instructions using L and R: "
instructions = gets.chomp

print "Enter max number of steps: "
max = gets.chomp.to_i

adam = Ant.new
grid = {}

# move the ant according to the rules
for i in 1..max do
	grid[adam.location] ||= 0
	adam.turn_cw if instructions[grid[adam.location] % instructions.length] == 'R'
	adam.turn_ccw if instructions[grid[adam.location] % instructions.length] == 'L'

	grid[adam.location] = (grid[adam.location] + 1) % instructions.length
	adam.move
end

# convert the collection of points into an array (for easy output to image)
output = []
i = 0
for w in grid.keys.map {|a| a.x }.min..grid.keys.map {|a| a.x }.max do
	output << []
	for h in grid.keys.map {|a| a.y}.min..grid.keys.map {|a| a.y }.max do
		output[i] << (grid[Point.new(w,h)] || 0)
	end
	i = i + 1
end

#output to png image
width = grid.keys.map {|a| a.x }.max - grid.keys.map {|a| a.x }.min
height = grid.keys.map {|a| a.y }.max - grid.keys.map {|a| a.y}.min
png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

for w in 0..width-1 do
	for h in 0..height-1 do
		# generates a darker shade of gray for higher values
		t = ((1 - output[w][h] * 1.0 / instructions.length) * 0xFF).to_i
		png[w,h] = ChunkyPNG::Color.rgb(t,t,t)
	end
end

png.save('output.png', :interlace => false)