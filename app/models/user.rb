class User < ActiveRecord::Base

  ROLES = %w[root admin member]

  def root?
    role == 'root'
  end

  def admin?
    role == 'admin'
  end

  def member?
    role == 'member'
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable , :authentication_keys => [:login]

  devise :invitable, :invite_for => 2.weeks

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login
  # attr_accessible :title, :body

  belongs_to :organization

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["(lower(username) = :value OR lower(email) = :value) and status is null", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  #-------------------验证-------------------------------------
  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {:with => /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i}
  validates :username, :uniqueness => true, :if => '! username.blank?'

end
