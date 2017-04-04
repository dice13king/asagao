class Member < ActiveRecord::Base
  include EmailAddressChecker

  has_many :entries, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :voted_entries, through: :votes, source: :entry
  has_one :image, class_name: "MemberImage", dependent: :destroy #imageと呼びたいため。本当のクラス名はmember_image
  accepts_nested_attributes_for :image, allow_destroy: true
  validates :number, presence: true,
    numericality: { only_integer: true,
      greater_than: 0, less_than: 100, allow_blank: true },
    uniqueness: true
  validates :name, presence: true,
    format: { with: /\A[A-Za-z]\w*\z/, allow_blank: true, message: :invalid_member_name },
    length: { minimum: 2, maximum: 20, allow_blank: true },
    uniqueness: { case_sensitive: false }
  validates :full_name, length: {maximum: 20 }
  validate :check_email
  validates :password, presence: { on: :create }, confirmation: { allow_blank: true }
     #新規作成時のみバリデイト(更新時はなし)。password_confirmationと比較してくれる。オプションは{}で囲む

  attr_accessor :password, :password_confirmation

  def password=(val)
    if val.present?
      self.hashed_password = BCrypt::Password.create(val)
    end
    @password = val
  end

  def votable_for?(entry)
    entry && entry.author != self && !votes.exists?(entry_id: entry.id)
  end

  private
  def check_email
    if email.present?
      errors.add(:email, :invalid) unless well_formed_as_email_address(email)
    end
  end

  class << self
    def search(query)
      rel = order("number")
      if query.present?
        rel = rel.where("name LIKE ? OR full_name LIKE ?", "%#{query}", "#{query}")
      end
      rel
    end

    def authenticate(name, password)
      member = find_by(name: name)
      if member && member.hashed_password.present? &&
        BCrypt::Password.new(member.hashed_password) == password
        member
      else
        nil
      end
    end
  end
end
