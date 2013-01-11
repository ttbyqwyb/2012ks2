#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "user"
require "./session.rb"

cgi = CGI.new
session = UserSession.new(cgi)
if session.login_check
  user = session.get_user
  probnum = cgi["probnum"].to_i
  sourcecode = cgi["sourcecode"]
  user.answer( {"probnum"=>probnum, "sourcecode"=>sourcecode} )
  print cgi.header({"status"=>"REDIRECT", "Location"=>"./answer_page.html"})
end
