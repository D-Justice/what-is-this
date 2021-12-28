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
    
    def self.navigate(page, max_pages)
        puts @@spacing + @@message_spacing + "To navigate type 'forward'(f) or 'back'(b), or 'home' to go back"
        input = gets.chomp.to_str.downcase
        case input
        when "forward", "f"
            self.forward(page, max_pages)
        when "back", "b"
            self.back(page)
        when "home"
            CLI.restart
        else
            puts "Unrecognised command, try again"
            self.navigate
        end

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