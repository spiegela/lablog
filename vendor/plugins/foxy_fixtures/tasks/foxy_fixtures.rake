namespace :db do
  namespace :fixtures do
    desc "Search for a fixture given a LABEL or ID."
    task :identify => :environment do
      require "active_record/fixtures"

      label, id = ENV["LABEL"], ENV["ID"]
      raise "LABEL or ID required" if label.blank? && id.blank?
    
      puts %Q(The fixture ID for "#{label}" is #{Fixtures.identify(label)}.) if label
    
      Dir["#{RAILS_ROOT}/test/fixtures/**/*.yml"].each do |file|
        if data = YAML::load(ERB.new(IO.read(file)).result)
          data.keys.each do |key|
            key_id = Fixtures.identify(key)
          
            if key == label || key_id == id.to_i
              puts "#{file}: #{key} (#{key_id})"
            end
          end
        end
      end
    end
  end
end