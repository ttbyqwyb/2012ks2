#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "./session.rb"

cgi = CGI.new
session = UserSession.new(cgi)

username = cgi["username"]
password = cgi["password"]
res = User.add( username, password )
if res == true
  session.login( username, password )
  print cgi.header({"status"=>"REDIRECT", "Location"=>"./home.cgi"})
else
  msg = res.result.error_message
  html = <<HTML
<html>
  <body>
    <p>
      error message: #{msg}
    </p>
    <a href="login_page.cgi">login_page</a>
  </body>
</html>
HTML
  cgi.out{html}
end
     
