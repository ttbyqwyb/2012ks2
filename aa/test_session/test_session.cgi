#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'

cgi = CGI.new
session = CGI::Session.new(cgi)

if session['foo'].nil?
  session['foo'] = true
  cgi.out{ "not yet set" }
else
  cgi.out{ "The value is " + session['foo'] + "\nclass is "  + session['foo'].class.to_s + session['bar'].class.to_s }
  session.delete
end
