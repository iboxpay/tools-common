#!/usr/bin/env ruby
#
# encoding: UTF-8
# File: simulate_server.rb
# This file use to simulate http api(json) server, use for apps developer,
# don't need to wait for backends implement all the code complement.
#
# Writen by Lytsing Huang 2013-11-19
# $Id$
#

require 'rubygems'
require 'json'
require 'timeout'
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

class BaseServlet < HTTPServlet::AbstractServlet
  def do_GET(req, resp)
    puts "Header: " + req.raw_header.to_s
    puts "Body: " + req.body
    resp['Content-type'] = "application/json; charset=utf-8"
    resp.body = {:status => 1}.to_json
  end

  # Respond with an HTTP POST just as we do for the HTTP GET.
  alias do_POST do_GET
end

class LoginServlet < BaseServlet
  def do_GET(req, resp)
    resp.status = 200 # Success
    resp.body = {:status => 1, :name => "lytsing Huang", :token => "2343423432", :rank => 2, :memberId => 10086, :logoUrl => "images/logo.png", :city => "Shenzhen", :level => 4 }.to_json
  end

  alias do_POST do_GET
end

class ClientUpdateServlet < BaseServlet
  def do_GET(req, resp)
    resp.body = {:status => 0, :fileSize => 2048, :md5 => "28a76acc891d0fd85966a27f34d897e0", :lastestVersion => "2.2.1", :fileURL => "http:\/\/wenku.baidu.com\/view\/91c69a0d7cd184254b3535d0.apk", :content => "amazing..."}.to_json
  end

  alias do_POST do_GET
end

start_webrick {|server|
  server.mount("/api/v2/client_update.json", ClientUpdateServlet);
  server.mount("/api/v2/login.json", LoginServlet);
  # TODO: add your code here.
}

