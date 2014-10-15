desc "test num"
task :test do
   sh "ruby main.rb Export_Output_2_utf.csv"
end

task :txt do 
    sh "ruby main.rb Export_Output_2_utf.csv > a.txt"
end

task :default => :test
