#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "user"
require "./session.rb"
require "functions"

cgi = CGI.new
session = UserSession.new(cgi)
if session.login_check
  user = session.get_user
  prob_num = cgi["prob_num"]
  prob_text = get_prob_text( prob_num )
  html =  <<HTML
<html>
  <head>
    <title>prob_page</title>
  </head>
  <body>
    <p>
      <b>Problem#{prob_num}</b>
      <div style="border-style:solid;border-width:1px;padding:10px">
	#{prob_text}
      </div>
    </p>
    <p>
      <b>Answer</b>
      <div style="border-style:solid;border-width:1px;padding:10px">
	<form method="post" action="answer.cgi">
	  ProblemNumber<br>
	  <input type="number" name="prob_num" value="#{prob_num}" size="4"><br><br>
	  Language<br>
	  <select name="language">
	    <option value="C++">C++</option>
	    <option value="Ruby">Ruby</option>
	  </select><br><br>
	  SourceCode<br>
	  <textarea name="source_code" cols="50" rows="10"></textarea><br>
	  <input type="submit" value="submit">
	</form>
      </div>
    </p>
    <p>
      <a href="./home.cgi">Back to home.</a>
    </p>
  </body>
</html>
HTML
  cgi.out{ html }
end
