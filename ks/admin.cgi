#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "pg"
require "settings"
require "table"
require "functions"

cgi = CGI.new
pg = Settings.get_pgconn

if cgi["delete_msg"] == "true"
  delete_msg
end

res = pg.exec("select * from users;")
ha = []
res.each do |h|
  ha << h
end
ha.each do |row|
  row["login"] = <<HTML
<form method="post" action="login.cgi">
  <input type="hidden" name="username" value="#{row["username"]}">
  <input type="hidden" name="password" value="#{row["password"]}">
  <input type="submit" value="login">
</form>
HTML
end

users_key = ["login", "userid", "username", "password", "score"]
users_ary = hashary_to_ary( users_key, ha )
users_table = ary_to_table( users_ary )

scores_key = DB::Scores_columns
sql = "select * from #{DB::Scores};"
res = pg.exec( sql )
scores_ary = hashary_to_ary( scores_key, res )
scores_table = ary_to_table( scores_ary )

messages_key = DB::Messages_columns
messages_ary = hashary_to_ary( messages_key, load_msg )
messages_table = ary_to_table( messages_ary )

html = <<HTML
<html>
  <head>
    <title>admin</title>
  </head>
  <body>
    <p>
      <a href="admin_logout.cgi">logout</a>
    </p>
    <p>
      user list<br>
      #{users_table}
    </p>
    <p>
      score list<br>
      #{scores_table}
    </p>
    <p>
      message list
      #{messages_table}
      <form method="post" action="admin.cgi">
	<input type="hidden" name="delete_msg" value="true">
	<input type="submit" value="delete all messages">
      </form><br>
    </p>
  </body>
</html>
HTML

cgi.out{ html }
