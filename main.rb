# -*- coding: UTF-8 -*-

require "erb"
require 'csv'

Class Unit
	attr_accessor :one,:two,:area
	def initialize(one,two,area)
		@one = one
		@two = two
		@area = area
	end
end

Class Land
	attr_accessor :num,:local,:units
	def initialize(num,local,units)
		@num = num
		@local = local
		@units = units
	end

	def area
		@units.inject(0){|sum,x| sum + x.area}
	end

	def area_gengdi
		gd = @units.select { |e| e.two == "耕地" }
		gd.inject(0){|sum,x| sum + x.area}
	end

	def area_nongyongdi
		gd = @units.select { |e| e.one == "农用地" }
		gd.inject(0){|sum,x| sum + x.area}
	end

	def area_weiliyongdi
		gd = @units.select { |e| e.one == "未利用地" }
		gd.inject(0){|sum,x| sum + x.area}
	end

	def area_jiansheyongdi
		gd = @units.select { |e| e.one == "建设用地" }
		gd.inject(0){|sum,x| sum + x.area}
	end
end

Class Project
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
	attr_accessor :name,:projects

	def initialize(name,projects)
		@name = name
		@projects = projects
	end

	def area
		@projects.inject(0){|sum,x| sum + x.area}
	end

	def length
		@projects.length
	end
end

Class  District
	attr_accessor :name,:input,:output

	def initialize(name,input,output)
		@name = name
		@input = input
		@output = output
	end

	def area
		input.area + output.area
	end

end

Class Downtown
	attr_accessor :xinbei,:wujing

	def initialize(xinbei,wujing)
		@xinbei = xinbei
		@wujing = wujing
	end

	def all_input_count
		@xinbei.input.length + @wujing.input.length
	end

	def all_input_area
		@xinbei.input.area + @wujing.input.area
	end

	def all_output_count
		@xinbei.output.length + @wujing.output.length
	end

	def all_output_area
		@xinbei.output.area + @wujing.output.area
	end


end


lines = CSV.open(ARGV[0]).readlines
keys = lines.delete lines.first
erb = ERB.new( temp.read )
output.write erb.result(binding)

lines.each do |i|
	bz = i[2]
	dkxh = i[3]
	tzlxdm = i[4]
	one = i[6]
	two = i[7]
	xzq_q = i[8]
	xzq_z = i[9]
	xzq_x = i[10]
	area = i[11].to_f

	unit = Unit.new(one,two,area)
end

wujing = lines.select { |e| xzq_q == "武进区" }
input = wuing.select{|e| tzlxdm == "I"}
output = wuing.select{|e| tzlxdm == "O"}

inputPrjects = {}
input.each do |e| 
	name = ""
	if e[2] == ""
		name = e[3]
	else
		name = e[2]
	end

	if inputPrjects.has_key?(name)
		inputPrjects[name] << e
	else
		inputPrjects[name] = []
	end
end



# wujing:name
         