#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'user'
require 'settings'

Table_name = 'users'

class UserSession < CGI::Session
  def initialize(*args)
    super(*args)
    if self['logined'] == "true"
      @logined = true
    else
      @logined = false
    end
  end
  def logined?
    return @logined
  end
  def login_check
    if @logined == true
      return true
    else
      print <<HEAD
Content-Type: text/html
Location: ./login_page.cgi

HEAD
      return false
    end
  end
  def get_user
    user = User.load(self['userid'])
    return user
  end
  def login( username, password )
    pg = Settings.get_pgconn
    return 0 if @logined
    @error_msg = ""
    pg_username = pg.escape(username)
    user_search = pg.exec("select * from #{Table_name} where username = '#{pg_username}';")
    if user_search.cmd_tuples == 0 and Settings::False_in_my_PC
      @error_msg = "Non-existing user."
    elsif user_search[0]['password'] == password
      @logined = true
    else
      @error_msg = "Incorrect password."
    end
    if @logined
      self['logined'] = 'true'
      self['userid'] = user_search[0]['userid'].to_s
    end
  end
  def get_error_msg
    return @error_msg
  end
end
