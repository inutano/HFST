# :)

# add current directory and lib directory to load path
$LOAD_PATH << __dir__
$LOAD_PATH << File.join(__dir__, "lib")

require 'sinatra'
require 'lib/hfst'

class HFST < Sinatra::Base
  helpers do
    def app_root
      "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["SCRIPT_NAME"]}"
    end
  end

  configure do
    set :experiments_list, HFST::ChIPAtlas.load_experiments("./public/data/chipatlas/chip_experiments.tab")
  end

  # routing
  get "/" do
    JSON.dump(settings.experiments_list)
  end

  post "/experiments" do
    ag  = params[:antigen]
    cln = params[:cell_line_name]
    
    ### DANGER ###
    @chipseq_data = HFST.get_chipseq(ag, cln, "./public/data/chipatlas/chip_experiments.tab", "/data/chipatlas")
    @rnaseq_data = HFST.get_rnaseq(cln, "./lib/sparql/ebi_biosample.rq", "./public/data/sra/SRA_Run_Members.tab")
    ### DANGER ###

    JSON.dump({:chipseq => @chipseq_data, :rnaseq => @rnaseq_data})
  end
end
