#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# login できているか判定して
# できていなかったら login フォームを表示
#  login フォーム： login.cgi に submit

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'page'
require 'member'

begin
  cgi = CGI.new
  session = CGI::Session.new(cgi)
  if session['userid'].nil?
    print cgi.header({'status' => 'REDIRECT', 'Location' => './login.cgi'})
  else
    member = Member.load(session['userid'])
    cgi.out{ HomePage.new({'member' => member}).page }
  end
#rescue PG::Error => ex
#  cgi.out{ LoginPage.new({'error_msg' => "PG::Error rescued."}).page }
#ensure
#  pg.close if pg
end

