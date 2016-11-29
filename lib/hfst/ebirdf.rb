require 'open-uri'
require 'json'

module HFST
  class EBIRDF
    def initialize(cell_line_name)
      @cln = cell_line_name
    end

    def query(template)
      q = open(template).read.sub(/CELL_LINE_NAME/,@cln.downcase)
      URI.encode_www_form_component(q)
    end

    def endpoint_url
      "https://www.ebi.ac.uk/rdf/services/biosamples/sparql"
    end

    def biosample_ids(template)
      res = JSON.load(open(endpoint_url + "?query=" + query(template) + "?format=JSON"))
      res["results"]["bindings"].map{|d| d["sampleid"]["value"]}.uniq # an array of biosample id
    end
  end
end
