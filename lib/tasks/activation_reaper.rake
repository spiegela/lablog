require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

namespace :activations do 
  desc 'Delete any expired activations'
  task :reap_expired => :environment do
    activations = Activation.find(:all,
      :conditions => [ 'completed_at is NULL' ] )
    activations.each do |activation|
      if activation.reservation.end_time <= Time.now
	if activation.in_use and
	  activation.reservation.find_all_conflicting_within_30_min.empty?
	  # Auto Extend Resevation by 1/2 hour
	  activation.reservation.end_time = Time.now + 1800
	  activation.reservation.save
	  puts "Auto-extending Reservation: #{activation.reservation.id}"
        else
	  activation.completed_at = Time.now
	  activation.save
	  puts "Forcibly Ending Activation: #{activation.reservation.id}"
        end
      end
    end
  end
end