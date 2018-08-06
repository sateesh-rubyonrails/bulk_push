class Message < ApplicationRecord

  def self.store_bulk_data
  	(1..100000).each do |id|  		
  		msg = {
  			header: {
  				id: id,
          created_at: Time.now
  			},
  			payload: {
  				name: Faker::Name.name,
          email: Faker::Internet.email,
          language: Faker::Nation.language,
          nationality: Faker::Nation.nationality ,
          capital_city: Faker::Nation.capital_city,
          national_sport: Faker::Nation.national_sport,
          phone_number: Faker::PhoneNumber.phone_number,
          cell_phone: Faker::PhoneNumber.cell_phone,
          area_code: Faker::PhoneNumber.area_code,
          job_title: Faker::Job.title,
          job_key_skill: Faker::Job.key_skill,
          education_level: Faker::Job.education_level,
          job_employment_type: Faker::Job.employment_type,
          job_position: Faker::Job.position,
          currency: {
            name: Faker::Currency.name,
            code: Faker::Currency.code,
            symbol: Faker::Currency.symbol
          } ,
          book: {
            title: Faker::Book.title,
            author: Faker::Book.author,
            publisher: Faker::Book.publisher,
            genre: Faker::Book.genre  
          }
  			}
  		}.to_json
  	  Message.create(message: msg)
  	end
  end

end
