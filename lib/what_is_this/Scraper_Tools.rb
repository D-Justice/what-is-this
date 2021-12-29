class CLI::Scraper_Tools
    @@spacing = "\n\n\n"
    @@message_spacing = "         "
    
    def self.page(doc)
        doc.css('.gems__meter').text.match(/[0-9]{3}/).to_s.to_i
    end
    def self.check_pagination(doc)
        
        doc.css(".pagination").text
        
    end
    def self.retry
        puts "Unable to complete request, please try again: "
    end
    
    def self.navigate(page, max_pages, all)
        puts @@spacing + @@message_spacing + "To navigate type 'forward'(f) or 'back'(b), or 'home' to go back \n
        To install a gem type install then its number (install 12)"
        input = gets.chomp.to_str.downcase
        
        case input
            when "forward", "f"
               page = self.forward(page, max_pages)
            when "back", "b"
                page = self.back(page)
            when "home"
                Approx_Scraper.clear_all_instances
                CLI.restart
            when /install [0-9]+/
                install_num = input.split()
                install_num = install_num[1].to_s.to_i
                CLI::Install.run_sys_command(all[install_num].name.to_s)
            else
                puts "Unrecognised command, try again"
                puts "install #{input[1]}"
                self.navigate(page, max_pages)
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