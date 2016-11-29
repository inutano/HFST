require "hfst/chipatlas"
require "hfst/ebirdf"
require "hfst/ebirnaseqapi"
require "hfst/sra"

module HFST
  class << self
    def get_chipseq(antigen, cell_line_name, experiments_list_fpath, base)
      ChIPAtlas.new(antigen, cell_line_name, experiments_list_fpath).bedfiles(base)
    end

    def get_rnaseq(cell_line_name, sparql_template, run_table)
      bs_ids = EBIRDF.new(cln).post(sparql_template)
      runids = bs_ids.map{|bsid| SRA.biosample_to_runid(run_table, bsid) }.flatten.uniq
      runids.map{|runid| EBIRNAseqAPI::Run.new(runid).bigwig_url }.flatten.uniq
    end
  end
end
