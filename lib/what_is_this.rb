# frozen_string_literal: true

require_relative "what_is_this/version"
require_relative "what_is_this/Advanced_Search"
require_relative "what_is_this/Approx_Scraper"
require_relative "what_is_this/Dependencies"
require_relative "what_is_this/Install"
require_relative "what_is_this/Scraper"

module WhatIsThis
  class Error < StandardError; end
  @@spacing = "\n\n\n"
    @@message_spacing = "         "
    def self.introduction
    
    
    introduction_message = '
                              $$\                   $$\             $$\                     $$\     $$\       $$\           
                              $$ |                  $$ |            \__|                    $$ |    $$ |      \__|          
                $$\  $$\  $$\ $$$$$$$\   $$$$$$\  $$$$$$\           $$\  $$$$$$$\         $$$$$$\   $$$$$$$\  $$\  $$$$$$$\ 
                $$ | $$ | $$ |$$  __$$\  \____$$\ \_$$  _|  $$$$$$\ $$ |$$  _____|$$$$$$\ \_$$  _|  $$  __$$\ $$ |$$  _____|
                $$ | $$ | $$ |$$ |  $$ | $$$$$$$ |  $$ |    \______|$$ |\$$$$$$\  \______|  $$ |    $$ |  $$ |$$ |\$$$$$$\  
                $$ | $$ | $$ |$$ |  $$ |$$  __$$ |  $$ |$$\         $$ | \____$$\           $$ |$$\ $$ |  $$ |$$ | \____$$\ 
                \$$$$$\$$$$  |$$ |  $$ |\$$$$$$$ |  \$$$$  |        $$ |$$$$$$$  |          \$$$$  |$$ |  $$ |$$ |$$$$$$$  |
                 \_____\____/ \__|  \__| \_______|   \____/         \__|\_______/            \____/ \__|  \__|\__|\_______/ '

        introduction_message.each_char {|c| putc c ; sleep 0.0015}
        puts @@spacing + @@message_spacing + "Welcome to what-is-this! To begin please type either dependencies, install, search or quit:"
        start
    end
    def self.start
        input = CGI.escape(gets.chomp.downcase.strip)
        puts @@spacing
        case input
            when 'search'
                puts @@spacing + @@message_spacing + 'Would you like your search to be approximate(approx), advanced, exact or back to return?'

                input = CGI.escape(gets.chomp.downcase.strip)
                case input
                when 'back'
                    self.restart
                when 'approximate', 'approx'
                    approximate_search
                when 'exact'
                    search
                when 'advanced'
                    AdvancedSearch.advanced_search_properties
                else
                    puts @@spacing + @@message_spacing + 'Command not recognised. Try again:'
                    restart
                end
            when 'install'
                install
            when 'dependencies'
                Dependencies.display_dependencies
            when 'quit'
                quit
            else
                puts @@spacing + @@message_spacing + 'Command not recognised, try again!'
                start
            end
    end
    def self.approximate_search
        puts  @@spacing + @@message_spacing + "Please input your search term:"
        query = CGI.escape(gets.chomp.downcase.strip)
        Approx_Scraper.get_approximate_data(query)
        restart
    end
    def self.search
        puts @@spacing + @@message_spacing + "Enter gem you would like to know about"
        query = CGI.escape(gets.chomp.downcase.strip)
        Scraper.getData(query)
        restart
    end
    def self.install
        puts @@spacing + @@message_spacing + "Enter the gem that you would like to install and save as a dependency or back to return"
        input = CGI.escape(gets.chomp)
        case input
        when 'back'
            restart
        else
            Install.install(input)
        end
        restart
    end
    def self.quit
        puts @@message_spacing + "Thanks for using 'what-is-this'... seeya!" + @@spacing
        exit 1
    end
    def self.restart 
        puts @@spacing + @@message_spacing + 'To continue, type either dependencies, install, search, or quit:'
        start
    end
end
