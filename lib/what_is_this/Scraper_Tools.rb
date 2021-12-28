class Scraper_Tools

    def self.page(doc)
        doc.css('.gems__meter').text.match(/[0-9]{3}/).to_s.to_i
        
    end
    def self.check_pagination(doc)
        
        doc.css(".pagination").text
        
    end
    def self.retry
        puts "Unable to complete request, please try again: "
    end
    
    
    
    
    
end