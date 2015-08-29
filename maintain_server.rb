#!/usr/bin/ruby
#
# encoding: UTF-8
# File: maintain_server.rb
# This file use to response http request and tell them the server is being maintain,
# and then change Nginx/Apache config and reload.
#
# Writen by Lytsing Huang 2013-12-03
#

require 'rubygems'
require 'json'
require 'webrick'
include WEBrick

$dir = Dir::pwd
$port = 8080

def start_webrick(config = {})
  config.update(:Port => $port, :DocumentRoot => $dir)
  server = HTTPServer.new(config)
  yield server if block_given?
  # Trap signals so as to shutdown cleanly.
  ['INT', 'TERM'].each {|signal|
    trap(signal) {server.shutdown}
  }
  server.start
end

start_webrick {|server|
  server.mount_proc('/') {|req, resp|
    puts "Header: " + req.raw_header.to_s
    #puts "Body: " + req.body
    resp['Content-type'] = "application/json; charset=utf-8"
    resp.body = {:status => 0, :descrption => "Server is down for maintenance, please try again later"}.to_json
  }
}

