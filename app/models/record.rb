class Record < ApplicationRecord
	belongs_to :user
	include RailsSortable::Model
  	set_sortable :batting_order  # indicate sort column
    
    require 'csv'
    def self.import(file, user)
	   #  	if Record.where(user_id: user).count == 0
	   #  		15.times do
				# Record.create(user_id: user)
	   #  		end
	   #  	end
	    	Record.where(user_id: user).each do |r|
	    		r.batting_order = 0
	    		r.selected = false
	    		r.save
	    	end
	    	    i=0
	        CSV.foreach(file.path, headers: true, encoding:'r:iso-8859-1:utf-8') do |row|
	            info = row.to_hash
	            r = Record.where(user_id: user)[i]
	            r.attributes = info
	            r.save
	            i+=1
	            	# for i in fnum..lnum
	            	# # if i < Record.where(user_id: user).count
	             #   #     a = Record.find(i)
	             #       a.attributes = info
	             #       a.save
	            	#   	Record.create! info
	         end
    end

    def batter_result
       all_cases = []
       self.attributes.each do |key, value|
          next if key == "selected"
          next if value.to_i > 10000
          value.to_i.times do 
             all_cases << key
          end
       end
       all_cases = all_cases - ["id", "user_id", "steal", "game", "batting_order"]
       return all_cases.sample
    end
end
