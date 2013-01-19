#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'user'
require 'page'
require './session.rb'

output_dir = "./file/"

cgi = CGI.new
session = UserSession.new(cgi)
if session.login_check
  user = session.get_user
  file = cgi.params['file'][0]
  filename = user.username + "_" + file.original_filename
  text = file.read
  open(output_dir + filename, "w"){|fh|
    fh.binmode
    fh.write text
  }
  cgi.out{ ResultOfUpload.new({'filename'=>filename, 'text'=>text}).page }
end


