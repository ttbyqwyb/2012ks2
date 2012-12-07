#!/usr/bin/ruby

# login できているか判定して
# できていなかったら login フォームを表示
#  login フォーム： login.cgi に submit

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'page/page'

begin
  cgi = CGI.new
  session = CGI::Session.new(cgi)
  if session['username'].nil?
    print cgi.header({'status' => 'REDIRECT', 'Location' => './login.cgi'})
  else
    cgi.out{ HomePage.new({'username' => session['username']}).page }
  end
rescue PG::Error => ex
  cgi.out{ LoginPage.new({'error_msg' => "PG::Error rescued."}).page }
ensure
  pg.close if pg
end

