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

  exps_list = File.join(chip_dir, "chip_experiments.tab")
  file exps_list do |t|
    experiments_url = "http://dbarchive.biosciencedbc.jp/kyushu-u/metadata/experimentList.tab"
    exps = `curl #{experiments_url} | awk -F '\t' '$2 == "hg19" && $3 == "TFs and others"'`.split("\n").first(3)
    open(t.name, "w"){|f| f.puts(exps) }
  end

  task :download_chipatlas_bedfiles => [chip_dir, exps_list] do |t|
    exps = open(exps_list).readlines
    puts "Downloading #{exps.size} bed files.."
    exps.each do |exp|
      expid = exp.split("\t")[0]
      outdir = File.join(chip_dir, expid.sub(/...$/,""))
      mkdir_p outdir
      out = File.join(outdir, "#{expid}.bed")
      sh "wget -q -O #{out} http://dbarchive.biosciencedbc.jp/kyushu-u/hg19/eachData/bed05/#{expid}.05.bed"
    end
  end

  task :modify_bedfiles => [chip_dir, exps_list] do |t|
    exps = open(exps_list).readlines
    exps.each do |exp|
      expid = exp.split("\t")[0]
      bedfile_path = File.join(chip_dir, expid.sub(/...$/,""), "#{expid}.bed")
      sh "mv #{bedfile_path} #{bedfile_path}.bu"

      header = "track name=\\\"#{expid}\\\" url=\\\"http://crispr.dbcls.jp/?accession=$$\\\""

      `cat #{bedfile_path}.bu | awk 'BEGIN{ print "#{header}" }{ sub($4, "ID=hg19:" $1 ":" $2 "-" $3); print $0 }' > #{bedfile_path}`
    end
  end

  task :download_sra_table do |t|
  end
end
