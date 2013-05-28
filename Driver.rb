require "./AmazonS3"
class Driver

	def initialize()
    @current_dir = "/"
    @AS3=AmazonS3.new
  end

	def authenticate(user,pass,&block)
		yield user=="username" && pass=="password"
	end

	def bytes(path,&block)
#		final_path = path=="/"? @current_dir : @current_dir=="/"? path : @current_dir+path
		yield @AS3.get_size_of(path)
	end

	def change_dir(path,&block)
		#final_path = path=="/"? @current_dir : @current_dir=="/"? path : @current_dir+path
		#puts final_path
		if @AS3.dir_exists?(path)
			yield true
		else
			yield false
		end
	end

	def dir_contents(path, &block)
		list=@AS3.get_contents_of(path).map{|i| dir_item(i)}
		yield list
	end

	def delete_dir(path, &block)
#		final_path = path=="/"? @current_dir : @current_dir=="/"? path : @current_dir+path
		begin
			@AS3.delete_dir(path)
		rescue
			yield false
		else
			yield true
		end
	end

	def delete_file(path, &block)
#		final_path = path=="/"? @current_dir : @current_dir=="/"? path : @current_dir+path
		begin
			@AS3.delete_file(path)
		rescue
			yield false
		else
			yield true
		end
	end

	def get_file(path, &block)
#		final_path = path=="/"? @current_dir : @current_dir=="/"? path : @current_dir+path
		yield @AS3.get_download_stream(path)
	end

	def put_file(path, tmp_file_path,&block)
		yield @AS3.upload(path)
	end

	def put_file_streamed(path, datasocket, &block)
		
		yield @AS3.upload(path)
	end

	def dir_item(name)
    EM::FTPD::DirectoryItem.new(:name => name, :directory => true, :size => 0)
  end

  def file_item(name, bytes)
    EM::FTPD::DirectoryItem.new(:name => name, :directory => false, :size => bytes)
  end

end

driver Driver