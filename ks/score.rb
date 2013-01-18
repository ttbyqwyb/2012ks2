#!/usr/bin/ruby

require 'rubygems'

Max_col = 10

def ary_to_hash( key, value )
  a = [key, value].transpose
  h = Hash[*a.flatten]
  return h
end

class Score
  attr_accessor :key, :score
  def initialize(str)
    str_to_score(str)
  end
  def str_to_score(str)
    if str.nil?
      @score = []
      @key = []
    else
      newline_split = str.split("\n")
      @key = newline_split.shift.split(",")
      @key = [] if @key.nil?
      comma_split = []
      newline_split.each do |row|
        comma_split << row.split(",",Max_col)
      end
      @score = []
      comma_split.each do |cs|
        @score << ary_to_hash( @key, cs )
      end
    end
  end
  def score_to_str
    str = ""
    @key.each do |k|
      str += k + ","
    end
    str = str.chop + "\n"
    @score.each do |s|
      @key.each do |k|
        str += s[k].to_s + ","
      end
      str = str.chop + "\n"
    end
    return str
  end
  def get( key, value )
    res = []
    @score.each do |s|
      res << s if s[key] == value
    end
    return res
  end
  def add_score( hash )
    @score.reject!{|h| h["prob_num"] == hash["prob_num"]}
    @score << hash
    @key = hash.keys | @key
  end
end

ScoreData = <<DATA
prob_num,solved,date,score
1,true,20121229,200
1,true,20121228,100
2,true,20121227,80
3,false,,
4,,,0
DATA

