class User < ActiveRecord::Base
  has_secure_password(validations: false)
  validates_confirmation_of :password, if: lambda { |m| !m.omniauth? && m.password.present? }
  validates_presence_of :password, on: :create, if: lambda { |m| !m.omniauth? }
  validates_presence_of :password_confirmation, if: lambda { |m| !m.omniauth? && m.password.present? }

  has_many :cars

  def self.providers
    {github: 'GitHub', google_oauth2: 'Google'}
  end
end
