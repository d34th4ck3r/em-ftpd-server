require "aws/s3"
class AmazonS3

	def initialize()
		@user="gautam"
		@s3 = AWS::S3.new(:access_key_id => 'AKIAJFPIHK4NAK4WUM5A',:secret_access_key => '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')
		@bucket = @s3.buckets['em-ftpd-trial']
	end

	def get_filename(key)
		return key.split("/").join("_")
	end

	def get_key(filename)
		return filename!="/"? filename[0]!="/"? @user+"/"+filename.split("_").join("/"): @user+filename.split("_").join("/") : @user
	end

	def upload(filename)
		key=get_key(filename)
		return @s3.buckets[@bucket.name].objects[key].write(:file => filename.split("/")[-1]).content_length
	end

	def download(filename)
		begin
			puts "filename = " +filename
			key=get_key(filename)
			puts "key=" + key
			local_filename=get_filename(key)
			File.open(local_filename, 'wb') do |file|
			  @s3.buckets[@bucket.name].objects[key].read do |chunk|
			    file.write(chunk)
			  end
	  	end
	  rescue
	  	return false
	  else
	  	return true
	  end
	end

	def get_download_stream(filename)
		begin
			key=get_key(filename)
			puts key
			return @s3.buckets[@bucket.name].objects[key].read
		rescue
			return false
		end
	end

	def get_size_of(filename)
		key=get_key(filename)

	end

	def get_contents_of(directory)
		list=[]
		key=get_key(directory)
		@bucket.objects.each{ |object|
			if object.key.include?(key)
				list=list+[object.key.split("/")[key.split("/").size]]
			end
		}
		return list.uniq
	end

	def dir_exists?(filename)
		key=get_key(filename)
		puts "key = "+ key
		@bucket.objects.each{ |object|
			if object.key.include?(key+"/")
				return true
			end
		}
		return false
	end

	def delete_file(filename)
		key=get_key(filename)
		return @bucket.objects[key].delete
	end

	def delete_dir(directory)
		key=get_key(directory)
		@bucket.objects.each{ |object|
			if object.key.include?(key)
				object.delete
			end
		}
	end
end