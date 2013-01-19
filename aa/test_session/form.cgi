#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'func'

#cgi = CGI.new
#session = CGI::Session.new(cgi)

out = <<OUT
<html>
  <body>
    <p>
      direct: cgi["fromform"] = #{1}<br>
      from func: cgi["fromform"] = #{get_fromform}
    </p>
    <p>
      <a href="./index.html">index</a>
    </p>
  </body>
</html>
OUT

cgi = CGI.new
cgi.out{ out }
