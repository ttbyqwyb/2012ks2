puts gets.split.map(&:to_i).inject{|a, b| a + b}
