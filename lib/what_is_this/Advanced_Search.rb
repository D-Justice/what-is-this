class CLI::AdvancedSearch
    attr_accessor :name, :markup, :downloads, :id
    @@spacing = "\n\n\n"
    @@message_spacing = "         "
    @@current_query = ""
    @@page = 1

    @@all = []

    def initialize(name = nil, markup = nil, downloads = nil, id = nil )
        @name = name
        @markup = markup
        @downloads = downloads
        @id = id
        @@all << self
    end
    def self.new_from_query
        CLI::Approx_Scraper.approx_names(@doc).each_with_index do |each, index|
            self.new(
                CLI::Approx_Scraper.approx_names(@doc)[index],
                CLI::Approx_Scraper.approx_markups(@doc)[index],
                CLI::Approx_Scraper.approx_downloads(@doc)[index],
                index + 1
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
        puts url
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
    def self.post_search_query
        search_results_found = CLI::Scraper_Tools.page(@doc)
        max_pages = (search_results_found / 30).ceil

        puts "Displaying page #{@@page} out of #{max_pages}"
        temp_page = @@page
        @@page = CLI::Scraper_Tools.navigate(@@page, max_pages, @@all)
        
        if (temp_page != @@page)
            self.clear_all_instances
        end
        self.advanced_search_scrape(@@current_query, @@page)

    end
    def self.clear_all_instances
        @@all = []
    end
    def self.display_data
        puts "======================================================="
        begin
            if (@@all.length >= 1)
                
                @@all.each do |each|
                    puts "---------------------------------"
                    puts ''
                    puts "##{each.id}"
                    puts ''
                    puts "About: #{each.name}"
                    puts ''
                    puts "Markup: #{each.markup}"
                    puts ''
                    puts "Downloads: #{each.downloads}"
                    puts ''
                    puts "---------------------------------"
                end
                
            if (CLI::Scraper_Tools.check_pagination(@doc) != "")
                self.post_search_query
                
            end
                CLI.restart
            else
                puts "0 search results found"
                self.restart
            end
        rescue => error
            puts error.message
            CLI::Scraper_Tools.retry
            self.restart
        end
        
    end
    

end