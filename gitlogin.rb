#!/usr/bin/env ruby
require 'yaml'
require_relative './lib/ssh_setup'


begin
  ssh_setup = SSHSetup.new(ARGV[0])
rescue => e
  puts e.message
  exit (e.is_a? SSHSetup::UserNotFoundError) ? 2 : 1
end

begin
  ssh_setup.login
rescue => e
  puts e.message
  exit 1
end

puts "Key will expire at #{ssh_setup.key_expiry}"