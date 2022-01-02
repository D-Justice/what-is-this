class CLI::Scraper_Tools
    @@spacing = "\n\n\n"
    @@message_spacing = "         "
    
    def self.page(doc)
        returned_gems = doc.css('.gems__meter').text.split()
        returned_gems[4].to_i

    end
    def self.check_pagination(doc)
        
        doc.css(".pagination").text
        
    end
    def self.retry
        puts "Unable to complete request, please try again: "
    end
    
    def self.navigate(page, max_pages, all)
        puts @@spacing + @@message_spacing + "For commands type: --help"
        help_message = @@spacing + @@message_spacing + "
        - forward, f => Go to next page \n
        - back, b => Go to previous page \n
        - first => Return to first page \n
        - last => Go to last page \n
        - page [number] => Jump to a certain page \n
        - install [number] => Install a certain gem as a dependency \n
        - inspect [number] => See full description of gem \n
        - home => Returns to start screen \n
        "
        input = gets.chomp.to_str.downcase
        
        case input
            when "--help"
                puts help_message
                self.navigate(page, max_pages, all)
            when "forward", "f"
               page = self.forward(page, max_pages)
            when "back", "b"
                page = self.back(page)
            when "home"
                CLI::Approx_Scraper.clear_all_instances
                CLI::AdvancedSearch.clear_all_instances
                CLI.restart
                
            when "first"
                page = 1
            when "last"
                page = max_pages
            when /page [0-9]+/
                install_num = input.split()
                page = install_num[1].to_s.to_i
            when /install [0-9]+/
                install_num = input.split()
                install_num = install_num[1].to_s.to_i - 1
                CLI::Install.run_sys_command(all[install_num].name.to_s)
            when /inspect [0-9]/
                inspect_num = input.split()
                inspect_num = inspect_num[1].to_s.to_i - 1
                CLI::Scraper.getData((all[inspect_num].name.to_s))
                puts "Would you like to install this gem?(Y/N)"
                input = gets.chomp
                case input
                    when "y"
                        CLI::Install.run_sys_command(all[inspect_num].name.to_s)
                        puts "Restarting"
                        CLI.restart
                    when "n"
                        puts "Please continue or select --help for help"
                    else
                        puts "Input not recognised, try again"
                        self.navigate(page, max_pages, all)

                end

                
            else
                puts "Unrecognised command, try again"
                self.navigate(page, max_pages, all)
        end
        page
    end
    def self.forward(page, max_pages)
        page += 1 unless page >= max_pages
        page
        
    end
    def self.back(page)
        page -=1 unless page <= 1
        page
    end
    
    
    
end