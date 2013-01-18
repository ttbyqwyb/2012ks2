#!/usr/bin/ruby

require 'rubygems'
require 'pg'

module Settings
  #directories
  Data_dir = "./data/"
  Answer_dir = Data_dir + "answer/"
  def prob_dir( prob_num )
    return Data_dir + "prob" + prob_num.to_s + "/"
  end
  def input_dir( prob_num )
    return prob_dir( prob_num ) + "in/"
  end
  def output_dir( prob_num )
    return prob_dir( prob_num ) + "out/"
  end
  
  # session.rb cmd_tuples
  False_in_my_PC = true
  
  def get_pgconn()
    pg = PG::Connection.connect('localhost', 5432, '', '', 'test', 'postgres', '' )
    return pg
  end
  module_function :get_pgconn, :prob_dir, :input_dir, :output_dir
end


