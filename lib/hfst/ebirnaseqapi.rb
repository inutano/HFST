require 'json'

module HFST
  class EBIRNAseqAPI
    class Run
      def initialize(runid)
        @runid = runid
      end

      def mapping_quality
        "90"
      end

      def get_run_data
        url = "http://www.ebi.ac.uk/fg/rnaseq/api/json/#{mapping_quality}/getRun/#{@runid}"
        JSON.load(open(url).read)
      end

      def bigwig_url
        get_run_data.each{|obj| obj["BIGWIG_LOCATION"] }
      end
    end
  end
end
