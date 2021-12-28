class CLI::Install
    
    def self.install(input)
        puts @@spacing + @@message_spacing + "Enter the gem that you would like to install and save as a dependency"
        input = CGI.escape(gets.chomp)
        system("bundle add #{input}") 
        puts @@spacing + @@message_spacing + "Gem installed!"
    end
    
    
end
