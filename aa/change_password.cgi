#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'user'
require './session.rb'

cgi = CGI.new
session = UserSession.new(cgi)
if session.login_check
  user = session.get_user
  msg = ""
  if cgi["new"] != cgi["verify"]
    msg = "Passwords did not match."
  else
    msg = user.change_password( cgi["old"], cgi["new"] )
  end
  ret = <<HTML
<html>
  <head>
    <title>Change password</title>
  </head>
  <body>
    <p>#{msg}</p>
    <p>
      <a href="./change_password.html">Retry</a>
      <a href="./home.cgi">Back to home</a>
    </p>
  </body>
</html>
HTML
  cgi.out{ ret }
end

