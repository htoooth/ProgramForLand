# coding: utf-8

require "erb"
require 'csv'
require_relative "head"

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
		area = gd.inject(0){|sum,x| sum + x.area}
	end

	def area_nongyongdi
		gd = @units.select { |e| e.one == "农用地" }
		area =  gd.inject(0){|sum,x| sum + x.area}
	end

	def area_weiliyongdi
		gd = @units.select { |e| e.one == "未利用地" }
		area = gd.inject(0){|sum,x| sum + x.area}
	end

	def area_jiansheyongdi
		gd = @units.select { |e| e.one == "建设用地" }
		area = gd.inject(0){|sum,x| sum + x.area}
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

	def area_nongyongdi
		@lands.inject(0){|sum,x| sum + x.area_nongyongdi}
	end

	def area_gengdi
		@lands.inject(0){|sum,x| sum + x.area_gengdi}
	end
end

class Region
	attr_accessor :name,:projects

	def area
		@projects.inject(0){|sum,x| sum + x.area}
	end

	def length
		@projects.inject(0){|sum,x| sum + x.length}
	end

	def project_length
		@projects.length
	end

	def to_s
		"#{@name},#{@projects}\n"
	end

	def get_all_out_land
		lands = []
		@projects.each do |p|
			lands.concat(p.lands)
		end

		l = lands.sort { |a, b| a.num <=> b.num }

		l.each { |e| yield(e) }
	end

end

class  District
	attr_accessor :name,:input,:output

	def area
		input.area + output.area
	end

	def input_land_length
		@input.length
	end

	def input_project_length
		@input.project_length
	end

	def input_area
		sprintf("%0.4f",@input.area)
	end

	def output_land_length
		@output.length
	end

	def output_project_length
		@output.project_length
	end

	def output_area
		sprintf("%0.4f",@output.area)
	end

end

class Downtown
	attr_accessor :xinbei,:wujing

	def all_input_count
		@xinbei.input.length + @wujing.input.length
	end

	def all_input_area
		area = @xinbei.input.area + @wujing.input.area
		sprintf("%0.4f",area)
	end

	def all_output_count
		@xinbei.output.length + @wujing.output.length
	end

	def all_output_area
		area = @xinbei.output.area + @wujing.output.area
		sprintf("%0.4f",area)
	end
end

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
		project.local = units.uniq{|q| q[9]}[0][9]
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
			land.local = units.uniq{|q| q[10]}[0][10]
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

		project.lands.sort!{|a,b| a.num <=> b.num}
		projects << project
	end

	return projects
end

def district_select(data,name)
	wujingdata = data.select { |e| e[8] == name }
	inputdata = wujingdata.select{|e| e[4] == "I"}
	outputdata = wujingdata.select{|e| e[4] == "O"}

	conditional = Region.new
	conditional.name = "调整的有条件建设区"
	conditional.projects = unit2project(inputdata)

	constructable = Region.new
	constructable.name = "调整的允许建设区"
	constructable.projects = unit2project(outputdata)

	wujin = District.new
	wujin.name = name
	wujin.input = conditional
	wujin.output = constructable

	return wujin
end

lines = CSV.open(ARGV[0],"r:utf-8").readlines
keys = lines.delete lines.first
wujin = district_select(lines,"武进区")
xinbei = district_select(lines,"新北区")

downtown = Downtown.new
downtown.wujing = wujin
downtown.xinbei = xinbei

# puts downtown.all_input_count
# puts downtown.all_input_area
# puts downtown.all_output_count
# puts downtown.all_output_area

youtiaojian = ERB.new Head::Template,0,1
yunxu = ERB.new Head::Template2,0,1

# head
puts youtiaojian.result(binding)
puts yunxu.result(binding)

youtiaojian_item = ERB.new Head::Template1,0,1
yunxu_item = ERB.new Head::Template3,0,1

## wujing
puts youtiaojian_item.result(binding)
puts yunxu_item.result(binding)


## xinbei
downtown.wujing = xinbei
puts youtiaojian_item.result(binding)
puts yunxu_item.result(binding)