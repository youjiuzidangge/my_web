class Transaction < ApplicationRecord
  scope :unrecorded, -> { where(is_recorded: false) }
  scope :recorded, -> { where(is_recorded: true) }
  enum category: { lent: 0, restored: 1, cancelled: 2 }

  belongs_to :user
  belongs_to :book
end