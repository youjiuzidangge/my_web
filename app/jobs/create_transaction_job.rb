class CreateTransactionJob < ApplicationJob
  queue_as :default
  rescue_from(LockNotGetError) do
    retry_job wait: (2 / SecureRandom.random_number(2..5).to_f)
  end

  def perform(user_id:, book_id:, quantity:, time:)
    stock = Redis.current.get("#{book_id}:bookStore").to_i
    return if stock <= quantity

    raise LockNotGetError unless Redis.current.set("lock", true, nx: true, ex: 5.minutes)

    ActiveRecord::Base.transaction do
      book = Book.find(book_id)
      user = User.find(user_id)

      users_book = UsersBook.where(user_id: user.id, book_id: book.id).take
      if users_book.present?
        users_book.update(quantity: quantity + users_book.quantity)
      else
        UsersBook.create(user_id: user.id, book_id: book.id, quantity: quantity)
      end

      Transaction.lent.create(
        quantity: quantity,
        total_fee: book.fee * quantity,
        user_id: user.id,
        username: user.username,
        book_id: book.id,
        book_title: book.title,
        loan_at: time
      )

      user.update!(balance: user.balance - quantity * book.fee)
      book.update!(stock: book.stock - quantity)

      Redis.current.decrby("#{book_id}:bookStore", quantity)
    end

    Redis.current.del("lock")
  end
end
