#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'member'
require 'page'

output_dir = "./file/"

cgi = CGI.new
session = CGI::Session.new(cgi)
if session['userid'].nil?
  print cgi.header({'status' => 'REDIRECT', 'Location' => './login.cgi'})
else
  member = Member.load(session['userid'])
  file = cgi.params['file'][0]
  filename = member.username + "_" + Time.now.to_s+ "_" + file.original_filename
  text = file.read
  open(output_dir + filename, "w"){|fh|
    fh.binmode
    fh.write text
  }
  cgi.out{ ResultOfUpload.new({'filename'=>filename, 'text'=>text}).page }
end


