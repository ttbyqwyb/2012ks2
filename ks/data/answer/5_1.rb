sum = 0
while line = STDIN.gets
  a = line.split
  a.each do |n|
    sum += n.to_i
  end
end
print "ff"