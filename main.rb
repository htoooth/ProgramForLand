require "erb"
require 'csv'

Class Land
	attr_accessor :num,:local,:f,:g,:w
	# f = nong yong di
	# g = geng di
	# w = wei li yong di
	# local = chun ming
	# num = di kuai bian hao
	def initialize(num,local,f,g,w)
		@num = num
		@local = local 
		@f = f
		@g = g
		@w = w
	end

	def area
		f + g
	end
end

Class Item
	attr_accessor :name,:local,:lands
	
	def initialize(name,local,lands)
		@name = name
		@local = local
		@lands = lands
	end

	def area
		@lands.inject(0){|sum,x| sum + x.area}
	end

	def length
		@lands.length
	end
end

Class Region
	attr_accessor :name,:items

	def initialize(name,items)
		@name = name
		@items = items
	end

	def area
		@itmes.inject(0){|sum,x| sum + x.area}
	end

	def length
		@itmes.length
	end
end

lines = CSV.open(ARGV[0]).readlines
keys = lines.delete lines.first
erb = ERB.new( temp.read )
output.write erb.result(binding)


# wujing:name
         