require 'open-uri'

namespace :hfst do
  directory DATA_DIR
  chip_dir = File.join(DATA_DIR, "chipatlas")
  directory chip_dir

  desc "initialize repository"
  task :init => [
    :download_chipatlas_bedfiles,
    :modify_bedfiles,
    :download_sra_table,
  ]

  task :download_chipatlas_bedfiles => chip_dir do |t|
    experiments_url = "http://dbarchive.biosciencedbc.jp/kyushu-u/metadata/experimentList.tab"
    exps = `curl #{experiments_url} | awk -F '\t' '$2 == "hg19" && $3 == "TFs and others"'`.split("\n").first(3)
    open(File.join(chip_dir, "chip_experiments.tab"), "w"){|f| f.puts(exps) }

    puts "Downloading #{exps.size} bed files.."
    exps.each do |exp|
      expid = exp.split("\t")[0]
      outdir = File.join(chip_dir, expid.sub(/...$/,""))
      mkdir_p outdir
      out = File.join(outdir, "#{expid}.bed")
      sh "wget -q -O #{out} http://dbarchive.biosciencedbc.jp/kyushu-u/hg19/eachData/bed05/#{expid}.05.bed"
    end
  end

  task :modify_bedfiles do |t|
  end

  task :download_sra_table do |t|
  end
end
