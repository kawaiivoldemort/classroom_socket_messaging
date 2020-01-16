require "socket"
load "ui.rb"

class MClient
    def self.get_your_ip
        addresses = Socket.ip_address_list
        addresses.each do |address|
            ip_parts = address.ip_address.split('.')
            if (ip_parts.count == 4) and !(ip_parts[0].eql? "127") then
                return address.ip_address
            end
        end
    end
    def initialize ip, port
        @server = nil
        begin
            @server = TCPSocket.open(ip, port)
            @server.set_encoding "ASCII-8BIT"
        rescue Exception => exception
            puts "#{UI.ui_settings[:retrying_error]}Error: #{exception.message} ... retrying in 2 seconds"
            sleep(2)
            retry
        end
    end
    def communicate
        send_thread = Thread.new do
            loop do
                puts "#{UI.ui_settings[:message]}"
                line = gets.chomp
                print "\033[2A\r"
                if ["end", "exit", "close"].include?(line.downcase) then
                    break
                end
                begin
                    @server.puts "#{line}"
                    if /(call me |my name is |alias )(?<ifalias>[a-z]+)/ === line.downcase then
                        print "#{a_reset}" + " "*(UI.winsize[0] - 1) + "\r"
                    end
                rescue Exception => exception
                    puts "#{UI.ui_settings[:stopping_error]}Error: #{exception} ... exiting" 
                    break
                end
            end
        end
        listen_thread = Thread.new do
            loop do
                message = ""
                begin
                    loop do
                        char = @server.read_nonblock(1)[0]
                        if char.eql? "\n"
                            break
                        end
                        message += char
                    end
                rescue IO::WaitReadable
                    sleep 0.2
                    IO.select([@server])
                    retry
                rescue
                    puts "#{UI.ui_settings[:stopping_error]}The server #{ip} seems to be offline"
                    break
                end
                message = message.split("|")
                if message.count == 3 then
                    puts "#{UI.ui_settings[:source]} #{message[0]} #{UI.ui_settings[:time]} #{message[1]} #{UI.ui_settings[:message]} #{message[2]}"
                end
            end
        end
        (ThreadsWait.new(listen_thread, send_thread).next_wait == send_thread ? listen_thread : send_thread).exit
    end
end