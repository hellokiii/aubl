class HomeController < ApplicationController
	before_action :login

  def dbupload

  end

  def upload
  	if Record.where(user_id: current_user.id).count == 0
  	    	25.times do
			Record.create(user_id: current_user.id)
    		end
    	end
    Record.import(params[:csv_file], current_user.id)
    redirect_to '/home/choose', notice: "완료!"
  end

  def choose
  	@all_batters = current_user.records
  end
  
  def check
    current_user.records.each do |r|
      r.selected = false
      r.batting_order = 0
      r.save
    end
    the_selected = params[:lineup]
    lineup = the_selected.split('"') - ["[", ",", "]"]
    lineup.each do |l|
       a = current_user.records.where(name: l).take
       a.batting_order = lineup.index(l) + 1
       a.selected = true
       a.save
    end
    redirect_to '/home/lineup'
  end
  def lineup
	if Record.where(user_id: current_user.id).count == 0
    		redirect_to '/home/dbupload'
     end
  	@picked = current_user.records.where(selected: true).order(batting_order: :asc)
  end

  def simulation
  	@lineup = current_user.records.where(selected: true).order(batting_order: :asc)
	advance = {"baseonballs": [1],
	     "hbp": [1],
	     "single": [0,1],
	     "double": [1,0],
	     "triple": [1,0,0],
	     "homerun": [1,0,0,0],
	     "pb": [0]
	    }
	inning = 1
	@result = []
	@score = 0
	batter_num = 1
	while inning < params[:innings].to_i + 1	
		runners = []
		@runners = []
		left_on_base = []
		@result << ""
	  	@result << inning.to_s + "inning"
	  	out = 0
  		
	  	while out < 3
		  	@lineup.drop(batter_num - 1).each do |l|
		  		result_of_the_batter = l.batter_result
		  		batter_num += 1
		  		if batter_num > 9
		  		  batter_num = 1
		  		end
		  		@result << "#{l.batting_order.to_s}번 타자 #{l.name}: #{result_of_the_batter}"
		  		if result_of_the_batter == "strikeout"
		  			out += 1
		  			if out == 3
		  				inning += 1
		  				# @result << runners
		  				@result << "#{runners.count(1) - runners.last(3).count(1)} 득점"
		  				break
		  			end
		  		elsif result_of_the_batter == "pb"
		  			out += 1
		  			if out == 3
		  				inning += 1
		  				# @result << runners
		  				@result << "#{runners.count(1) - runners.last(3).count(1)} 득점"
		  				break
		  			else
		  				runners += advance[:pb]
		  			end
		  		else
		  			runners += advance[result_of_the_batter.to_sym]
		  		end
		  	end

	  	end
	  	# @runners = runners
	  	left_on_base = runners.last(3)
	  	@score = @score + runners.count(1) - left_on_base.count(1)
	  end
	end


	def average
		@sum = 0.to_f
		1000.times do 
			simulation
			@sum += @score
		end
	end
end
