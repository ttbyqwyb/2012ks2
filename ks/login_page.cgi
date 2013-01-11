#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'page'
require 'user'
require './session.rb'

cgi = CGI.new
session = UserSession.new(cgi)
if session.logined?
  print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
else
  cgi.out{ LoginPage.new({}).page }
end



