class Website < ApplicationRecord

  validates :url, presence: true

  belongs_to :account

end
