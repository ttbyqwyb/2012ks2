#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'

cgi = CGI.new
session = CGI::Session.new(cgi)

session.delete

print cgi.header({'status'=>'REDIRECT','Location'=>'./index.html'})
