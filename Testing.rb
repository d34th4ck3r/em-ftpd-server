require "rspec"
require "net/ftp"

class FTPTester

	def initialize()
		@ftp = Net::FTP.new('127.0.0.1')
	end

	def able_to_authenticate?(username,password)
		return @ftp.login(username,password)
	end

	def able_to_list_directories?(user,pass,path)
		@ftp.login(user,pass)
		return (not @ftp.list(path).nil?)
	end

	def able_to_move_to_sub_directory?(user,pass,directory)
		@ftp.login(user,pass)
		begin
			@ftp.chdir(directory)
		rescue
			return false
		else
			return true
		end
	end

	def able_to_upload?(user,pass,filename)
		@ftp.login(user,pass)
		begin
			@ftp.put(filename)
		rescue
			return false
		else
			return true
		end
	end

	def able_to_download?(user,pass,filename)
		@ftp.login(user,pass)
		begin
			@ftp.get(filename)
		rescue
			return false
		else
			return true
		end
	end

end

describe FTPTester do 

	it "should be able to authenticate" do
		tester= FTPTester.new
		tester.should be_able_to_authenticate("username","password")
	end

	it "should be able to list directories" do
		tester= FTPTester.new
		tester.should be_able_to_list_directories("username","password","/")
	end

	it "should move to sub directory" do
		tester= FTPTester.new
		tester.should be_able_to_move_to_sub_directory("username","password","directory")
	end

	it "should be able to upload" do
		tester= FTPTester.new
		tester.should be_able_to_upload("username","password","file1")
	end

	it "should be able to download" do
		tester= FTPTester.new
		tester.should be_able_to_download("username","password","testing")
	end

end