=begin
+-------------------------+                                                                                                   
|  FALLOUT HACKING GAME   |                                                                                                   
|  #163-I                 |                                                                                                   
|  http://redd.it/263dp1  |                                                                                                   
+-------------------------+  
=end

words = []
f = File.open("enable1.txt","r") #https://dotnetperls-controls.googlecode.com/files/enable1.txt
while(line = f.gets)
	words << line.chomp
end

difficulty = 0
loop do
	printf "Enter difficulty level (1-5): "
	input = gets.chomp
	
	case input
	when "1" then
		difficulty = 4
	when "2" then
		difficulty = 5
	when "3" then
		difficulty = 7
	when "4" then
		difficulty = 9
	when "5" then
		difficulty = 11
	else
		next
	end
	break
end

#trim word list to difficulty number of characters
words.select!{|w| w.length == difficulty}

#select words at random
game_words = words.sample(difficulty+3)
game_words.each do |w|
	printf "%s\n" % w.upcase
end

#pick the game word
password = game_words.sample(1).first

round = 1
winner = false
while round <= 4 do
	printf "Guess #%d: " % round
	guess = gets.downcase.chomp
	if !game_words.include?(guess) then
		printf "That is not a guessable word.\n"
		next
	elsif guess == password then
		printf "Correct!\n"
		winner = true
		break
	end
	
	#count matching characters
	matching = 0
	for i in 0..(password.length-1) do
		matching = matching + 1 if guess[i] == password[i]
	end
	
	printf "%d/%d correct.\n" % [matching, password.length]
	round = round + 1
end

unless winner then
	printf "You lose! The word was %s.\n" % password.upcase
end
