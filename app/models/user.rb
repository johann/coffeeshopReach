class User < ActiveRecord::Base
	has_many :orders, :dependent => :destroy
	before_save :prepare_password



  	def self.authenticate(login, pass)
    	user = find_by_username(login) || find_by_email(login)
    	return user if user && user.matching_password?(pass)
  	end

  	def matching_password?(pass)
    	self.password_hash == encrypt_password(pass)
  	end

  	private

  	def prepare_password
    	unless password.blank?
      		self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      		self.password_hash = encrypt_password(password)
    	end
  	end

  	def encrypt_password(pass)
    	Digest::SHA1.hexdigest([pass, password_salt].join)
  	end
end
