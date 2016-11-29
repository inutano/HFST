module HFST
  class SRA
    class << self
      def biosample_to_runid(run_table, biosampleid)
        `cat #{run_table} | awk -F '\t' '$9 == #{biosampleid} { print $1 }'`.split("\n")
      end
    end

    def initialize(run_table)
      @runs = load_table(run_table)
    end

    def load_table(run_table)
      open(run_table).readlines.map{|line| line.chomp.split("\t") }
    end
  end
end
