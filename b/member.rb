#!/usr/bin/ruby

require 'rubygems'
require 'pg'
require 'settings'



class Member
  attr_reader :userid, :username
  def initialize(userid, username, password)
    @userid = userid
    @username = username
    @password = password
  end
  def mytest()
    return "aaa"
  end
  public :test
end

def Member.load(userid)
  pg = get_pgconn
  user_search = pg.exec("select * from members where userid = '#{userid}'")
  if user_search.nil?
    print "Non existing id"
  else
    u = user_search[0]
    return Member.new(u['userid'], u['username'], u['password'])
  end
end
