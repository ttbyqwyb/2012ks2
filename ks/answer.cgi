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
  prob_num = cgi["prob_num"].to_i
  source_code = cgi["source_code"]
  language = cgi["language"]
  result = user.answer( {"prob_num"=>prob_num, "source_code"=>source_code, "language"=>language} )
  score = session.get_user.load_score
  html = <<HTML
<html>
  <body>
    verdict : #{result["verdict"]}<br>
    <a href="answer_page.html">answer_page</a>
    <a href="home.cgi">home</a>
  </body>
</html>
HTML
  cgi.out{ html }
end
