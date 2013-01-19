#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'settings'
require 'score'

class User
  attr_reader :userid, :username, :score
  def initialize(userid, username, password)
    @userid = userid
    @username = username
    @password = password
  end
  def load_score
    pg = get_pgconn
    user_search = pg.exec("select * from users where userid = #{@userid}")
    u = user_search[0]
    @score = Score.new(u['score'])
  end
  def change_password( old, new )
    if @password != old
      return "Wrong password."
    else
      pg = get_pgconn
      pg.exec("update users set password = '#{new}' where userid = #{@userid};")
      return "Your password has been changed."
    end
  end
  def answer( args )
    filename = @userid.to_s + "_" + args["probnum"].to_s
    text = args["sourcecode"]
    save_file( "./data/answer/" + filename, text )
  end
end

def User.load(userid)
  pg = get_pgconn
  user_search = pg.exec("select * from users where userid = '#{userid}'")
  if user_search.nil?
    print "Non-existing id."
  else
    u = user_search[0]
    return User.new(u['userid'], u['username'], u['password'])
  end
end

def save_file( pass, text )
  open( pass, "w" ){|fh|
    fh.binmode
    fh.write text
  }
end
