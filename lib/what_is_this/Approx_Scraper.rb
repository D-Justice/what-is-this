class CLI::Approx_Scraper
    attr_accessor :name, :markup, :downloads, :id
    @@page = 1
    @@current_query = ""

    @@all = []

    def self.get_approximate_data(query, page = 1)
        @@current_query = query
        url = "https://rubygems.org/search?page=#{page}&query=#{query}"
        @doc = Nokogiri::HTML(open(url))
        self.new_from_query
    end
    def initialize(name=nil, markup=nil, downloads=nil, id=nil)
        @name = name
        @markup = markup
        @downloads = downloads
        @id = id
        @@all << self
    end
    def self.new_from_query
        
        approx_names(@doc).each_with_index do |each, index|
            self.new(
                approx_names(@doc)[index],
                approx_markups(@doc)[index],
                approx_downloads(@doc)[index],
                index + 1

            )
        end
        
        display_approx
    end
    def self.approx_names(doc)
        begin
            doc.css('h2').css('.gems__gem__name').text.gsub(/[[:space:]]/, ' ').gsub(/[0-9].\S+/, '').split()
        rescue => error
            puts "I hit an error"
            puts error.message
        end
    end
    def self.approx_markups(doc)
        doc.css('.gems__gem__desc').map do |i|
            "#{i.text} "
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
        self.get_approximate_data(@@current_query, @@page)

    end
    def self.approx_downloads(doc)
        doc.css('.gems__gem__downloads__count').text.gsub(/[[:space:]]/, ' ').gsub(/Downloads/, '').split()
    end
    def self.clear_all_instances
        @@all = []
    end
    def self.display_approx
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
            CLI::Advanced_Search.restart
        end
    rescue => error
        puts error.message
        CLI::Scraper_Tools.retry
    end
    end


end