class Account < ApplicationRecord

  before_create :set_access_token
  has_many :websites

  private

  def set_access_token
    self.access_token = SecureRandom.uuid
  end
end
