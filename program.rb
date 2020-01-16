require "socket"
load "client.rb"
load "ui.rb"

your_ip = MClient.get_your_ip
puts "#{UI.ui_settings[:prompt]}Your IP is #{your_ip}"
print "#{UI.ui_settings[:prompt]}Enter the Server IP:#{UI.ui_settings[:prompt_input]}" 
ip = gets.chomp
print "#{UI.ui_settings[:prompt]}Enter the Port Number(1024-49151):#{UI.ui_settings[:prompt_input]}"
port = gets.to_i
server = MClient.new ip, port
print "#{UI.ui_settings[:prompt]}Success"
server.communicate
puts UI.a_reset