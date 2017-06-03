require "cgi"
require "json"
require "net/http"
require "time"
module Sparql
  class HttpJson
    def self.get(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      if url.start_with?("https://")
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      JSON.parse(response.body)
    end
  end

  class Query
    attr_reader :raw_response, :raw_results, :prefixes, :prefixes_ttl
    def initialize(fuseki_url, query, prefixes = default_prefixes)
      @fuseki_url = fuseki_url
      @query = query
      @prefixes = prefixes
      @prefixes_ttl = prefixes_to_ttl(prefixes)
      @verbose = true
      @logger = nil
      @raw_response = {}
      @raw_results = []
      if @query && !@query.empty?
        execute()
      end
    end

    def execute()
      start = Time.now
      log_msg("-- QUERY\r\n#{@prefixes_ttl}#{@query}\r\n--")
      query_with_prefixes = (@prefixes_ttl + @query).gsub(/\n/, ' ')
      query_escaped = CGI.escape(query_with_prefixes)
      url = "#{@fuseki_url}?query=#{query_escaped}&output=json&stylesheet="
      # TODO: Do we need to use HTTP POST to support (very) large queries?
      @raw_response = HttpJson.get(url)
      log_elapsed(start, "-- QUERY")
      @raw_results = @raw_response["results"]["bindings"]
    end

    def default_prefixes
      p = []
      p << {prefix: "rdf",        uri: "http://www.w3.org/1999/02/22-rdf-syntax-ns#"}
      p << {prefix: "rdfs",       uri: "http://www.w3.org/2000/01/rdf-schema#"}
      p
    end

    def prefixes_to_ttl(prefixes)
      ttl = ""
      prefixes.each do |p|
        ttl += "prefix #{p[:prefix]}: <#{p[:uri]}> \n"
      end
      ttl
    end

    # Returns an array of hashes. Each hash has the results
    # for a single row, e.g: results[0] = {k1: v1, k2: v2}
    # Notice that we are losing whether the value is a literal
    # or a URI, since we treat them all as literals here.
    def results
      @hashes ||= begin
        @raw_results.map do |row|
          hash = {}
          row.keys.each do |key|
            hash[key.to_sym] = row[key]["value"]
            lang = row[key].fetch("xml:lang", nil)
            hash[:xml_lang] = "@#{lang}" if lang != nil
          end
          hash
        end
      end
    end

    # Returns the first value in the first element.
    # We assume the client expects a single value.
    def to_value
      return nil if results.count == 0
      results.first.values.first
    end

    private
      def elapsed_ms(start)
        ((Time.now - start) * 1000).to_i
      end

      def log_elapsed(start, msg)
        log_msg("#{msg} took #{elapsed_ms(start)} ms")
      end

      def log_msg(msg)
        return if @verbose == false
        if @logger
          @logger.info msg
        else
          puts msg
        end
      end
  end
end


# Run a sample query
fuseki_url = "http://localhost:3030/testdb/sparql"
query = <<-END_SPARQL
SELECT ?subject ?predicate ?object
WHERE {
  ?subject ?predicate ?object .
}
LIMIT 25
END_SPARQL

sparql = Sparql::Query.new(fuseki_url, query)
sparql.results.each do |row|
  puts row
end
