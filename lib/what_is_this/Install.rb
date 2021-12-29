class CLI::Install
    
    def self.install
        puts @@spacing + @@message_spacing + "Enter the gem that you would like to install and save as a dependency"
        input = CGI.escape(gets.chomp)
        self.run_sys_command(input)
    end
    def self.run_sys_command(input)
        system("bundle add #{input}") 
        puts @@spacing + @@message_spacing + "Gem installed!"

    end
    
end
