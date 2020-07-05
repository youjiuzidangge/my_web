class Transaction < ApplicationRecord
  scope :unrecord, -> { where(is_recorded: false) }
  enum category: { lent: 0, restored: 1, cancelled: 2 }
end