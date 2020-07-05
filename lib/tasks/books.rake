# frozen_string_literal: true

namespace :books do
  desc "to calculate the total income of restored books every 10 minutes"
  task calculate_incomes: :environment do
    Transaction.restored.unrecorded.find_each do |tran|
      ActiveRecord::Base.transaction do
        book = tran.book
        book.update(income: tran.total_fee + book.income)

        tran.update(is_recorded: true)
      end
    end
  end

  desc "to cancel transaction which is overtime every 3 minutes"
  task cancel_invalid_transaction: :environment do
    current_time = Time.zone.now
    Transaction.lent.unrecorded.find_each do |tran|
      next if current_time - tran.loan_at < 5.minutes

      tran.cancelled!
    end
  end

  desc "to deal with cancelled transaction every 5 minutes"
  task refund_to_users: :environment do
    Transaction.cancelled.unrecorded.find_each do |tran|
      ActiveRecord::Base.transaction do
        user = tran.user
        user.update(balance: user.balance + tran.total_fee)

        book = tran.book
        book.update(stock: book.stock + tran.quantity)
      end
    end
  end
end