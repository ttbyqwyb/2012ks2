#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "page"

cgi = CGI.new
session = CGI::Session.new(cgi)

session.delete
cgi.out{LogoutPage.new().page}
