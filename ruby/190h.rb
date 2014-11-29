=begin
+-------------------------+                                                                                                   
|  COMPLEX NUMBERS        |                                                                                                   
|  #190-H                 |                                                                                                   
|  http://redd.it/2nr6c4  |                                                                                                   
+-------------------------+  
=end

class Imagnum
	# format is: @a + @b*i
	attr_reader :a, :b

	def initialize(a, b = 0)
		@a = a
		@b = b
	end
	
	def +(a)
		if a.is_a? Fixnum or a.is_a? Float
			return Imagnum.new(@a + a, @b)
		elsif a.is_a? Imagnum
			return Imagnum.new(@a + a.a, @b + a.b)
		end
	end
	
	def -(a)
		if a.is_a? Fixnum or a.is_a? Float
			return Imagnum.new(@a - a, @b)
		elsif a.is_a? Imagnum
			return Imagnum.new(@a - a.a, @b - a.b)
		end
	end
	
	def *(a)
		if a.is_a? Fixnum or a.is_a? Float
			return Imagnum.new(@a * a, @b * a)
		elsif a.is_a? Imagnum
			return Imagnum.new(@a * a.a - @b * a.b, @a * a.b + @b * a.a)
		end
	end
	
	def modulus
		return Math.sqrt(@a**2 + @b**2)
	end
	
	def conjugate
		return Imagnum.new(@a, -@b)
	end
	
	def to_s
		if @a == 0 
			if @b > 1
				return "%si" % @b
			elsif @b == 1
				return "i"
			elsif @b == 0
				return "0"
			elsif @b == -1
				return "-i"
			elsif @b < -1
				return "-%si" % -@b
			end
		end
		
		if @b > 1
			return "%s+%si" % [@a, @b]
		elsif @b == 1
			return "%s+i" % @a
		elsif @b == 0
			return "%s" % @a
		elsif @b == -1
			return "%s-i" % @a
		elsif @b < -1
			return "%s-%si" % [@a, -@b]
		end
	end
end

a = Imagnum.new(1, 3)
b = Imagnum.new(3, -2)
puts a+b
puts a-b
puts a*b