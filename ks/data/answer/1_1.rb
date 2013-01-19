line = STDIN.gets
sum = 0
line.split.each do |a|
 sum += a.to_i
end
print sum