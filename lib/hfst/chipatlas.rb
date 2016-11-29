module HFST
  class ChIPAtlas
    class << self
      def load_experiments(fpath)
        open(fpath).readlines.map{|line| line.chomp.split("\t") }
      end
    end

    def initialize(antigen, cell_line, experiments_list_fpath)
      @ag = antigen
      @cl = cell_line
      @list = experiments_list_fpath
    end

    def bedfiles(base_dir)
      expids = `cat #{@list} | awk -F '\t' '$4 == "#{@ag}" && $6 == "#{@cl}" { print $1 }'`.split("\n")
      expids.map{|id| File.join(base_dir, id.sub(/...$/,""), id + ".bed") }
    end
  end
end
