require "erb"

temp = File.open(ARGV[0], "r")
data = File.opne(ARGV[1], "r")
output = File.opne(ARGV[2], "w")

erb = ERB.new( temp.read )
output.write erb.result(binding)
