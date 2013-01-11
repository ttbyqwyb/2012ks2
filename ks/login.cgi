#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require './session.rb'
require 'page'

cgi = CGI.new
session = UserSession.new(cgi)
if session.logined?
  print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
else
  session.login( cgi['username'], cgi['password'] )
  if session.logined?
    print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
  else
    cgi.out{ LoginPage.new({'error_msg' => session.get_error_msg}).page }
  end
end
