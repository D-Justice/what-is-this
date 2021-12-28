class CLI::Scraper
    attr_accessor :name, :markup, :downloads
    
    def initialize(name = nil, markup = nil, downloads = nil)
        @name = name
        @markup = markup
        @downloads = downloads
    end
    
    def self.getData(name)
        @doc = Nokogiri::HTML(open("https://rubygems.org/gems/#{name}"))
        instance = self.new(name, self.markup, self.downloads)
        exact_display(instance)
    end
    def self.markup
        @doc.css('#markup').text.strip
    end
    def self.downloads
        @doc.css('.gem__downloads').first.text.strip
    end
    def self.exact_display(instance)
        query = instance.name.split(' ')
        query = query.map do |word|
            word.capitalize
        end.flatten
        puts "======================================================="
        puts "--------#{query}--------"
        puts ''
        puts "About: #{self.markup}"
        puts ''
        puts "Downloads: #{self.downloads}"
        puts ''
        puts "---------------------------------"
    end

end