class CLI::AdvancedSearch
    attr_accessor :name, :markup, :downloads
    @@spacing = "\n\n\n"
    @@message_spacing = "         "
    @@current_query = ""
    @@page = 1

    @@all = []

    def initialize(name = nil, markup = nil, downloads = nil )
        @name = name
        @markup = markup
        @downloads = downloads
        @@all << self
    end
    def self.new_from_query
        Approx_Scraper.approx_names(@doc).each_with_index do |each, index|
            self.new(
                Approx_Scraper.approx_names(@doc)[index],
                Approx_Scraper.approx_markups(@doc)[index],
                Approx_Scraper.approx_downloads(@doc)[index]
            )
        end
        display_data
    end

    def self.advanced_search_properties
        puts @@spacing + @@message_spacing + "This is advanced search, please input name, summary, description, downloads, and when it was last updated or put nothing to skip a section"
        puts @@spacing + "Name: (ie: active OR action)"
        name = gets.chomp
        name != "" ? name = "name: #{name} " : name = ""

        puts "Summary: (ie: ORM, NoSQL)"
        summary = gets.chomp
        summary != "" ? summary = "summary: #{summary} " : summary = ""

        puts "Description: (ie: associations AND validations)"
        description = gets.chomp
        description != "" ?  description = "description: #{description} " : description = ""

        puts "Downloads: (ie: >20000)"
        downloads = gets.chomp
        downloads != "" ? downloads = "downloads: #{downloads} " : downloads = ""

        puts "Last Updated: (ie: >2021-12-12)"
        updated = gets.chomp
        updated != "" ? updated = "updated: #{updated} " : updated = ""

        query = CGI.escape((name + summary + description + downloads + updated).strip)

        puts "YOUR QUERY IS: " + query

        query.gsub!("++", "+")
        @@current_query = query
        self.advanced_search_scrape(query)
    end
   
    def self.advanced_search_scrape(query, page = 1)
        url = "https://rubygems.org/search?page=#{page}&query=#{query}"
        @doc = Nokogiri::HTML(open(url)) 
        self.new_from_query

    end
    def self.retry
        puts "Unable to complete request, please try again: "
        advanced_search_properties
    end
    def self.restart
        puts "Search another term? (y/n)"
        input = gets.chomp.downcase
    case input
        when "y"
            self.advanced_search_properties
        when "n"
            CLI.restart
        else
            self.advanced_search_properties
        end
    end
    def self.display_data
        puts "======================================================="
        begin
            if (@@all.length >= 1)
                
                @@all.each do |each|
                    puts "---------------------------------"
                    puts ''
                    puts "About: #{each.name}"
                    puts ''
                    puts "Markup: #{each.markup}"
                    puts ''
                    puts "Downloads: #{each.downloads}"
                    puts ''
                    puts "---------------------------------"
                end
                search_results_found = @@all.length
                puts "#{search_results_found} results found"
                puts Approx_Scraper.page(@doc)
                if (Approx_Scraper.check_pagination(@doc) != "")
                    @@page = self.navigate(@@page)
                    self.advanced_search_scrape(@@current_query, @@page)
                end
                self.restart
            else
                puts "0 search results found"
                self.restart
            end
        rescue => error
            puts error.message
            self.retry
        end
        
    end
    def self.navigate(page)
        puts @@spacing + @@message_spacing + "To navigate type 'forward'(f) or 'back'(b), or 'home' to go back"
        input = gets.chomp.to_str.downcase
        case input
        when "forward", "f"
            self.forward(page)
        when "back", "b"
            self.back(page)
        when "home"
            CLI.restart
        else
            puts "Unrecognised command, try again"
            self.navigate
        end

    end
    def self.forward(page)
        page += 1 
        page
        
    end
    def self.back(page)
        page -=1 unless page =< 0
        page
    end

end