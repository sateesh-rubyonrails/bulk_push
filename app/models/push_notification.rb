class PushNotification < ApplicationRecord
   def self.bulk_push
      loop do
        puts "\n\n\n 11111111111111 Starting of the loop <<<<#{Process.pid} 1111111111"
     	  push_obj = PushNotification.last
     	  puts push_obj.inspect

     	  PushNotification.last.with_lock do
       	  max_id = PushNotification.pluck(:end_id).max.to_i
  	   	  puts ">>>>>>>>>>>>>..Max Id <<<<<<<<<<<<"
  	   	  puts  max_id.inspect
  	   	  puts "**********************************"
     	    @messages = Message.where("id> ?", max_id).order(:id).limit(10)
          # if $count.present?
          #   $count = $count + @messages.count
          # else
          #   $count = @messages.count
          # end
          # # puts ">>>>>>>>>>>>>>> $count value <<<<<<<<<"
          # puts $count
          if @messages.count == 0   #$count >= 50
            @break_loop = true
            return
          end
    	    PushNotification.create(start_id: @messages.first.id, end_id: @messages.last.id)            
     	  end
        break if @break_loop
        process_messages(@messages)
      end
   end

   def self.process_messages(messages)
   	 puts ">>>>> &&&&&&&&&&&&& Now I am processing my messages >>>>>> &&&&&&&& >>>>>>>>"
   	 puts messages.pluck(:id).inspect
     json_ary = messages.collect{|msg| msg.message}

      xml_ary = []
      messages.each do |message|
        json_msg = message.message
         xml_msg = ActiveSupport::JSON.decode(json_msg).to_xml
         xml_ary << xml_msg
      end
     DataValidation.create!(start_id: messages.first.id, end_id: messages.last.id, xml_messages_ary: xml_ary, json_messages_ary: json_ary, process_id: Process.pid)
     sleep(0.5)
   end	
end
