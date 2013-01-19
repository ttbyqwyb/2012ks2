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
require 'user'
require './session.rb'

begin
  cgi = CGI.new
  session = UserSession.new(cgi)
  if session.login_check
    user = session.get_user
    cgi.out{ HomePage.new({'user' => user}).page }
  end
#rescue PG::Error => ex
#  cgi.out{ LoginPage.new({'error_msg' => "PG::Error rescued."}).page }
#ensure
#  pg.close if pg
end

