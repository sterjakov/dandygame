module FileHelper

  def extract_filename path
    File.basename(path.to_s).to_s
  end

end
