#!/usr/bin/ruby

require 'rubygems'
require 'pg'

def get_pgconn()
  pg = PG::Connection.connect('localhost', 5432, '', '', 'test', 'postgres', '' ) 
  return pg
end

# session.rb cmd_tuples
