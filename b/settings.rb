#!/usr/bin/ruby

require 'rubygems'
require 'pg'

def get_pgconn()
  pg = PG::Connection.connect('localhost', 5432, '', '', 'test', 'postgres', 'topology' ) #'topology' is password in Wakatsuki's PC
  return pg
end

# login.cgi L28 cmd_tuples
