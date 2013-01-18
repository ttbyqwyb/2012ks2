#!/usr/bin/ruby
# -*- coding: undecided -*-

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'page'
require 'user'
require 'settings'
require './session.rb'

table_name = 'users';

begin
  cgi = CGI.new
  session = UserSession.new(cgi) #CGI::Session.new(cgi)
  if ! session.logined? #session['userid'].nil?
    pg = Settings.get_pgconn
    username = cgi['username']
    password = cgi['password']
    login_success = false
    error_msg = ""
    if /^\w{1,8}$/ =~ username
      pg_username = pg.escape(username)
      user_search = pg.exec("select * from #{table_name}
        where username = '#{pg_username}'
      ;");
      if false and user_search.cmd_tuples == 0 #In my PC, always cmd_tuples == 0
        error_msg = "Non-existing user."
      else
        if user_search[0]['password'] == password
          login_success = true
        else
          error_msg = "Incorrect password."
        end
      end
    else
      error_msg = "Invalid username."
    end
    if login_success
      session['userid'] = user_search[0]['userid'].to_s
      session['logined'] = "true"
      print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
    else
      cgi.out{ LoginPage.new({'error_msg' => error_msg}).page + "fe"}
    end
  else
    print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
  end
rescue PG::Error => ex
  cgi.out{ LoginPage.new({'error_msg' => "PG::Error rescued.#{ex.to_s}"}).page + "erer" }
ensure
  pg.close if pg
end

