require "eventmachine"
module FTPS
	module ClassMethods
		
	end
	
	module InstanceMethods
		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end

	def receive_data(data)
		p data
		send_data "This is sent from server"
	end
end




EventMachine::run {
  EventMachine::start_server "127.0.0.1", 5000, FTPS
  puts 'running echo server on 8081'
}