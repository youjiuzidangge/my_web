class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.paginate(page:params[:page],per_page: 20)
  end

  def ack
    user_id = params[:user_id]
    book_id = params[:book_id]
    loan_at = params[:borrow_time]

    job_id = params[:job_id]

    if Sidekiq::Status::status(job_id).nil? || Sidekiq::Status::failed?(job_id)
      return render_success_data("already sold out", SOLD_OUT_ERR_CODE)
    end

    unless Sidekiq::Status::complete?(job_id)
      execute_retry(job_id)
    end

    unless Sidekiq::Status::complete?(job_id)
      return render_success_data(
          "already sold out and money will be refund in 24 hours",
          SOLD_OUT_AND_REFUND_ERR_CODE
      )
    end

    transaction = Transaction.lent.where(
      user_id: user_id, book_id: book_id, is_recorded: false, loan_at: loan_at
    ).take

    if transaction.blank?
      return render_success_data("already sold out", SOLD_OUT_ERR_CODE)
    end

    ActiveRecord::Base.transaction do
      transaction.update(is_recorded: true)
      Redis.current.decrby("#{book_id}:purchaseFlag", transaction.quantity)
    end

    render_success_data("success", SUCCESS_CODE)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:title, :stock, :fee)
  end

  def execute_retry(job_id)
    retry_time = 1
    loop do
      retry_time += 1
      sleep(30.seconds)
      break if Sidekiq::Status::complete?(job_id) || retry_time > 5
    end
  end
end
