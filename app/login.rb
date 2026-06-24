# frozen_string_literal: true
# encoding: utf-8

def login(username, password)
  user = User.find_by(username: username)
  return nil unless user&.authenticate(password)

  user
end

if __FILE__ == $PROGRAM_NAME
  require_relative '../config/environment'

  username = ARGV[0]
  password = ARGV[1]

  if username.nil? || password.nil?
    warn 'Usage: ruby app/login.rb <username> <password>'
    exit 1
  end

  user = login(username, password)
  if user
    puts user.as_json.to_json
  else
    puts 'Unauthorized'
    exit 1
  end
end
