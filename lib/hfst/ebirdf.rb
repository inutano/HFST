require 'net/https'
require 'json'

module HFST
  class EBIRDF
    def initialize(cell_line_name)
      @cln = cell_line_name
    end

    def build_query(template)
      query = open(template).read.sub(/CELL_LINE_NAME/,@cln.downcase)
      URI.encode(query)
    end

    def endpoint_url
      URI.parse("https://www.ebi.ac.uk/rdf/services/biosamples/sparql")
    end

    def post(template)
      http = Net::HTTP.new(endpoint_url.host, endpoint_url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(endpoint_url.path)
      req.set_form_data({
        "query" => build_query(template),
        "format" => "json",
      })

      res = http.request(req)
      JSON.load(res)["results"]["bindings"].map{|d| d["sampleid"]["value"]}.uniq # returns array of biosample id
    end
  end
end
