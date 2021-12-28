class CLI::Dependencies
    @@spacing = "\n\n\n"
    @@message_spacing = "         "
    @@dependencies = []
    
    def self.display_dependencies
        print = false
        text = File.readlines('Gemfile.lock').each do |line|
            line = line.to_str
            if (line == "DEPENDENCIES\n")
                print = true
            else
                if (line == "BUNDLED WITH\n")
                    print = false
                elsif (print == true)
                    if (!@@dependencies.include?(line.split[0]))
                        @@dependencies << line.split[0] unless line.split[0].nil?
                    end
                    puts line

                    
                end
            end
            
        end
        self.enquire
    end
    def self.enquire
        puts @@message_spacing + "List the gem you would like to delete, or type 'back'" + @@spacing
        p @@dependencies
        input = gets.chomp
        case input
        when "back"
            CLI.restart
        else 
            if (@@dependencies.include?(input))

                system("gem uninstall #{input}")
                system("bundle remove #{input}")
                system("bundle install")
                @@dependencies.delete(input)
                self.display_dependencies
                
            else
                puts @@message_spacing + "Command not recognised. Try again" + @@spacing
                self.enquire
            end
            
        
        end
    end

end