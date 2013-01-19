#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"

cgi = CGI.new
session = CGI::Session.new(cgi)

session.delete
print <<HEAD
Content-Type: text/html
Location: ./admin.cgi

HEAD
