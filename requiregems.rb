begin
  require 'cinch'
rescue LoadError
  puts "You're missing the gem `cinch`. Would you like to install this now? (y/n)"
  input = gets.chomp
  if input == 'y'
    `gem install cinch`
    puts 'Gem installed! Continuing..'
  else
    puts 'To continue, install the cinch gem'
    exit
  end
end
begin
  require 'restclient'
rescue LoadError
  puts "You're missing the gem `rest-client`. Would you like to install this now? (y/n)"
  input = gets.chomp
  if input == 'y'
    `gem install rest-client`
    puts 'Gem installed! Continuing..'
  else
    puts 'Without rest-client, commands like !cat, !trbmb, !youtube, and many more will not work! It is recommended to say n, unless you are testing a plugin that does not require rest-client, continue? (y/n)'
    input = gets.chomp
    if input == 'n'
      puts 'To continue, install the rest-client gem'
      exit
    end
  end
end
require 'json'
require 'net/http'
require 'yaml'
begin
  require 'nokogiri'
rescue LoadError
  puts "You're missing the gem `nokogiri`. Would you like to install this now? (y/n)"
  input = gets.chomp
  if input == 'y'
    `gem install nokogiri`
    puts 'Gem installed! Continuing..'
  else
    puts 'Without Nokogiri, !cat will not work. Continue? (y/n)'
    input = gets.chomp
    if input == 'n'
      puts 'To continue, install the nokogiri gem'
      exit
    end
  end
end
require 'open-uri'
require 'base64'
