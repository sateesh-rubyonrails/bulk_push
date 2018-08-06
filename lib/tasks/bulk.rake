#require '../../app/models/notify'

namespace :bulk do
	task :test => :environment do
		#puts "<<<<<<< Inside bulk test method >>>>>>>>"
		PushNotification.bulk_push
	end

	task :execute => :environment do
    start_time = Time.now
    puts "Starting time is :#{start_time}"
		@is_running = true
        threads = []
        2.times do
          th = Thread.new do 
            true while @is_running
            a = `rake bulk:test`
            puts a
          end
          threads << th
        end
        puts "Total threads"
        puts threads.inspect
 		@is_running = false
 		threads.each(&:join)
    end_time = Time.now
    puts "Ending Time is : #{end_time}"
    difference = (end_time - start_time)/60

    puts "Total time taken: #{difference}"

 	end

 	def call_notify_obj
 		@notify ||= Notify.instance
 	end

 	def test1
 		call_notify_obj
		@notify.process
 	end
end
