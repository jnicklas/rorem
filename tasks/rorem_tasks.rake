namespace :rorem do
  
  desc "Fill all models with random data or specify a model with MODEL"
  task :fill => :initialize_rorem do
    puts "Filling with Rorem\n"
    
    if ENV['MODEL']
      model = eval(ENV['MODEL'])
      model.fill
    else
      Rorem::Filler.models.each do |a|
        model, count = a
        puts "-> Filling #{model}"
        model.fill count
      end
    end
  end
  
  namespace :fill do
    
    desc "Simulate the filling of all models (or a single model with MODEL)."
    task :simulate => :initialize_rorem do
      puts "\nRorem Simulation\n"
      
      simulate_fill_model = proc{|model|
        puts "simulating filling of model '#{model}'"
        puts "=========================================\n"
        record = model.new
        
        record.fill
        model.column_names.each do |cn|
          
          puts "=> " << cn << ":\t\t\t" << record.send(cn).to_s
          
        end
        
        puts "WARNING: the record is not valid: #{record.errors.full_messages.join(', ')}" unless record.valid?
        puts ''
      }
      
      if ENV['MODEL']
        model = eval(ENV['MODEL'])
        simulate_fill_model.call(model)
      else
        Rorem::Filler.models.each do |a|
          model, count = a
          simulate_fill_model.call(model)
        end
      end
    end
    
  end
end