#!/usr/bin/ruby

require "settings"

dirs = [Settings::Data_dir, Settings::Answer_dir]
dirs.each do |dir|
  if !File.exist?(dir)
    Dir.mkdir(dir)
  end
end
