#!/usr/bin/ruby

require "rubygems"
require "cgi"
require "cgi/session"
require "pg"
require "settings"
require "table"

cgi = CGI.new
pg = get_pgconn
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
key = ["login", "userid", "username", "password", "score"]
ary = hashary_to_ary( key, ha )
table = ary_to_table( ary )

html = <<HTML
<html>
  <head>
    <title>admin</title>
  </head>
  <body>
    <p>
      user listttt<br>
      #{table}
    </p>
    <a href="admin_logout.cgi">logout</a>
  </body>
</html>
HTML

cgi.out{ html }
