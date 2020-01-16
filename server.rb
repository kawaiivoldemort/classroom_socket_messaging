require "socket"
load "ui.rb"

your_ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
puts "#{UI.ui_settings[:source]}Your IP is : " + your_ip
print "#{UI.ui_settings[:message]}Input the Comms Port(1024-49151) : "
port = gets.to_i
clients = Array.new
client_names = Hash.new
server = TCPServer.open your_ip, port
while new_client = server.accept
    client_thread = Thread.new do
        this_client = new_client
        clients.each do |client|
            if client.peeraddr[3].eql? this_client.peeraddr[3] then
                puts "#{UI.ui_settings[:retrying_error]}Redundant Connection"
                Thread.kill client_thread
            end
        end
        this_client.set_encoding "ASCII-8BIT"
        puts "#{UI.ui_settings[:prompt]}New client added - #{this_client.peeraddr[3]}"
        clients.push this_client
        client_names[this_client.peeraddr[3]] = this_client.peeraddr[3].to_s;
        loop do
            message = ""
            begin
                loop do
                    char = this_client.read_nonblock(1)[0]
                    if char.eql? "\n"
                        break
                    end
                    message += char
                end
            rescue IO::WaitReadable
                IO.select([this_client])
                sleep 0.2
                retry
            rescue
                puts "#{UI.ui_settings[:stopping_error]}#{this_client.peeraddr[3]} has disconnected"
                clients.delete(this_client)
                client_names.delete(this_client.peeraddr[3]);
                break;
            end
            /(call me |my name is |alias )(?<ifalias>[a-z]+)/ =~ message.downcase
            if ifalias != nil then
                client_names[this_client.peeraddr[3]] = ifalias;
            else
                clients.each do |client|
                    begin
                        client.puts "#{client_names[this_client.peeraddr[3]]}|#{Time.now.strftime('%H:%M%p')}|#{message}"
                    rescue
                        puts "#{UI.ui_settings[:retrying_error]}#{client.peeraddr[3]} is offline"
                    end
                end
            end
        end
    end
end