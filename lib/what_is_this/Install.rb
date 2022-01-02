class CLI::Install
    @@spacing = "\n\n\n"
    @@message_spacing = "         "

    def self.install
        puts @@spacing + @@message_spacing + "Enter the gem that you would like to install and save as a dependency or back to return"
        input = gets.chomp
        case input
        when "back"

        else
            self.run_sys_command(CGI.escape(input))
        end
    end
    def self.run_sys_command(input)
        system("bundle add #{input}") 
        puts @@spacing + @@message_spacing + "Gem installed!"

    end
    
end
