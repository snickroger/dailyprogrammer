require "time"
=begin
+-------------------------+                                                                                                   
|  AVERAGE SPEED CAMERA   |                                                                                                   
|  #181-I                 |                                                                                                   
|  http://redd.it/2hcwzn  |                                                                                                   
+-------------------------+  
=end

lines = []
f = File.open("181i-data.txt","r")
while(line = f.gets)
	lines << line.chomp
end

speed_limit = 0
speed_unit = ""

# get the speed limit
lines[0].scan(/^Speed limit is ([0-9.]+) (mph|km\/h)\.$/) { |a,b| speed_limit, speed_unit = a.to_f,b }
speed_limit *= 1.60934 if speed_unit == "mph"

current_line = 1
# get the speed distances
camera_distances = []
car_times = {}
until lines[current_line][1] == 't' do
	lines[current_line].scan(/([0-9]*) me/) { |a,_| camera_distances << a.to_i }
	current_line += 1
end

# get the times per vehicle per camera
until lines[current_line].nil? do
	if lines[current_line][1] != 't' then
		license = ""
		pass_time = nil
		lines[current_line].scan(/^Vehicle ([A-Z0-9 ]+) passed camera [0-9]* at ([0-9:]*)\.$/) { |a,b| license,pass_time = a, Time.parse(b) }
		car_times[license] ||= []
		car_times[license] << pass_time
	end
	current_line += 1
end

# now calculate the speed for each car in km/h
car_times.each do |k,v|
	for i in 0..(camera_distances.length-2) do
		speed = (camera_distances[i+1]-camera_distances[i])/(v[i+1]-v[i]) * 3.6
		next if speed < speed_limit
		speed_excess = speed - speed_limit
		speed_excess *= 0.621371 if speed_unit == "mph"
		printf "Vehicle %s broke the speed limit by %.1f %s.\n" % [k, speed_excess, speed_unit]
	end
end