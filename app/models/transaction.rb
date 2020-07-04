class Transaction < ApplicationRecord
  enum category: { lent: 0, restored: 1 }
end
