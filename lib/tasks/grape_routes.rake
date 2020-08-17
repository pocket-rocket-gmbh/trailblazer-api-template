namespace :grape do
  desc 'Print compiled grape routes'
  task :routes => :environment do
    Api.routes.each do |route|
      puts "#{route.options[:method]} - Path: #{route.path} #{'-'*5} Namespace: #{route.namespace}"
    end
  end
end
