require_relative 'push_notification.rb'
class Notify
	   include Singleton

	def initialize
		@mutex = Mutex.new 
    end

    def process
    	puts "\n\n Caliing process emthod (********"
    PushNotification.bulk_push(@mutex)
    end
end