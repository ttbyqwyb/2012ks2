#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'page/page'

table_name = 'members';

begin
  cgi = CGI.new
  session = CGI::Session.new(cgi)
  if session['username'].nil?
    pg = PG::Connection.connect('localhost', 5432, '', '', 'test', 'postgres', '')
    username = cgi['username']
    password = cgi['password']
    login_success = false
    error_msg = ""
    if /^\w{1,8}$/ =~ username
      pg_username = pg.escape(username)
      user_search = pg.exec("select * from #{table_name}
        where username = '#{pg_username}'
      ;");
      if user_search.cmd_tuples == 0
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
      session['username'] = username
      print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
    else
      cgi.out{ LoginPage.new({'error_msg' => error_msg}).page }
    end
  else
    print cgi.header({'status' => 'REDIRECT', 'Location' => './home.cgi'})
  end
rescue PG::Error => ex
  cgi.out{ LoginPage.new({'error_msg' => "PG::Error rescued."}).page }
ensure
  pg.close if pg
end

