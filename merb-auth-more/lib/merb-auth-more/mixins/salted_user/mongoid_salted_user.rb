class Merb::Authentication
  module Mixins
    module SaltedUser
      module MongoidClassMethods
        def self.extended(base)
          base.class_eval do

            field :crypted_password, :type => String

            if Merb::Authentication::Mixins::SaltedUser > base
              field :salt, :type => String
            end
            
            validates_presence_of :password, :if => proc{|m| m.password_required?}
            validates_confirmation_of :password, :if => proc{|m| m.password_required?}
            
            before_save   :encrypt_password
          end # base.class_eval
          
        end # self.extended
        
        def authenticate(login, password)
          @u = first(:conditions => { Merb::Authentication::Strategies::Basic::Base.login_param => login })
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # MongoidClassMethods      
    end # SaltedUser
  end # Mixins
end # Merb::Authentication
