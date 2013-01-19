#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'func'

cgi = CGI.new
session = CGI::Session.new(cgi)

out = <<OUT
<html>
  <body>
    <p>
      direct: session["foo"] = #{session["foo"]}<br>
      from func: session["foo"] = #{get_foo}
    </p>
    <p>
    <a href="./index.html">index</a>
    </p>
  </body>
</html>
OUT

cgi.out{ out }
