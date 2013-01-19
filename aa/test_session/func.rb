#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'

def get_foo
  cgi = CGI.new
  session = CGI::Session.new(cgi)
  return session["foo"]
end

def get_fromform
  cgi = CGI.new
  return cgi["fromform"]
end
