class HomeController < ApplicationController
	before_action :login

  def dbupload
  end

  def upload
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
  	@picked = current_user.records.where(selected: true).order(batting_order: :asc)
  end


  def average
  end

  def five_inning
  	@lineup = current_user.records.where(selected: true)
  	inning = 1
  end
end
