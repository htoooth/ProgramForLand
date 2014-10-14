# coding: utf-8

require "erb"
require 'csv'

class Unit
	attr_accessor :one,:two,:area

	def to_s
		"#{@one},#{@two},#{@area}\n"
	end
end

class Land
	attr_accessor :num,:local,:units

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

	def to_s
		str = ""
		str = "#{@num},#{@local[0]},"
		units.each { |e| str += e.to_f + "\n" }
	end
end

class Project
	attr_accessor :name,:local,:lands
	
	def area
		@lands.inject(0){|sum,x| sum + x.area}
	end

	def length
		@lands.length
	end

	def to_s
		"#{@name},#{@local[0][0]},#{@lands}\n"
	end
end

class Region
	attr_accessor :name,:projects

	def area
		@projects.inject(0){|sum,x| sum + x.area}
	end

	def length
		@projects.length
	end

	def to_s
		"#{@name},#{@projects}\n"
	end
end

class  District
	attr_accessor :name,:input,:output

	def area
		input.area + output.area
	end

end

class Downtown
	attr_accessor :xinbei,:wujing

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


lines = CSV.open(ARGV[0],"r:utf-8").readlines
keys = lines.delete lines.first

# lines.each do |i|
# 	bz = i[2]
# 	dkxh = i[3]
# 	tzlxdm = i[4]
# 	one = i[6]
# 	two = i[7]
# 	xzq_q = i[8]
# 	xzq_z = i[9]
# 	xzq_x = i[10]
# 	area = i[11].to_f

# 	unit = Unit.new(one,two,area)
# end

wujing = lines.select { |e| e[8] == "武进区" }
inputdata = wujing.select{|e| e[4] == "I"}
outputdata = wujing.select{|e| e[4] == "O"}

def unit2project(input)
	inputPrjects = {}

	input.each do |e| 
		name = e[2]==""? e[3]:e[2]
		if inputPrjects.has_key?(name)
			inputPrjects[name] << e
		else
			inputPrjects[name] = [e]
		end
	end


	projects = []

	inputPrjects.each do |name,units|
		# puts name,units.length
		project = Project.new
		project.name = name
		project.local = units.uniq{|q| q[9]}
		project.lands = []

	    lands = {}	
		units.each do |e|  
			if lands.has_key?(e[3])
				lands[e[3]] << e
			else
				lands[e[3]] = [e]
			end
		end

		# if lands.has_key?("005")
		# 	puts lands["005"]
		# end

		lands.each do |key,units|
			land = Land.new
			land.num = key
			land.local = units.uniq{|q| q[10]}
			land.units = []

			units.each do |e|  
				u = Unit.new
				u.one = e[6]
				u.two = e[7]
				u.area = e[11].to_f

				land.units << u
			end

			project.lands << land
		end

		projects << project
	end	

	return projects
end

conditional = Region.new
conditional.name = "有条件调为允许"
conditional.projects = unit2project(inputdata)
puts conditional.area
