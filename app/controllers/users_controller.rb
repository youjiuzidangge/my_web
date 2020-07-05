class UsersController < ApplicationController
  before_action :set_user, only: %i[detail restore borrow edit update destroy]

  def index
    @users = User.order(id: :desc).paginate(page:params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end

  def detail; end

  def show
    redirect_to users_path, notice: 'edit success.'
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def restore
    book_id = params[:book_id]
    quantity = params[:quantity].to_i
    book = Book.find(book_id)

    users_book = UsersBook.where(user_id: @user.id, book_id: book.id).take
    if users_book.blank? || quantity > users_book.quantity
      return render_success_data('restore too many books', STORE_TOO_MANY_BOOKS_ERR_CODE)
    end

    ActiveRecord::Base.transaction do
      if quantity == users_book.quantity
        users_book.destroy
      else
        users_book.update(quantity: users_book.quantity - quantity)
      end

      Transaction.restored.create(
        quantity: quantity,
        total_fee: book.fee * quantity,
        user_id: @user.id,
        username: @user.username,
        book_id: book.id,
        book_title: book.title,
        loan_at: Time.zone.now
      )
      book.update(stock: book.stock + quantity)
    end
    render_success_data('success', SUCCESS_CODE)
  end

  def borrow
    book_id = params[:book_id]
    quantity = params[:quantity].to_i

    if quantity <= 0
      return render_success_data('wrong parameter', WRONG_PARAMETER_ERR_CODE)
    end

    unless Redis.current.exists("#{book_id}:bookStore")
      book = Book.find(book_id)
      Redis.current.set("#{book_id}:bookStore", book.stock, nx: true, ex: 10.minutes)
      Redis.current.set("#{book_id}:bookFee", book.fee, nx: true, ex: 10.minutes)
    end

    book_stock = Redis.current.get("#{book_id}:bookStore").to_i
    book_fee = Redis.current.get("#{book_id}:bookFee").to_i

    if quantity > book_stock
      return render_success_data('the stock is not enough', STOCK_NOT_ENOUGH_ERR_CODE)
    end

    Redis.current.set("#{book_id}:purchaseFlag", 0, nx: true, ex: 10.minutes)
    purchase_flag = Redis.current.get("#{book_id}:purchaseFlag").to_i
    if quantity + purchase_flag > book_stock
      return render_success_data('the stock is not enough', STOCK_NOT_ENOUGH_ERR_CODE)
    end

    Redis.current.incrby("#{book_id}:purchaseFlag", quantity)
    Rails.logger.info("this is flag: #{Redis.current.get("#{book_id}:purchaseFlag")}")

    if @user.balance < quantity * book_fee
      return render_success_data("user's balance is not enough", BALANCE_NOT_ENOUGH_ERR_CODE)
    end

    time = Time.zone.now.to_s

    job = CreateTransactionJob.set(wait: 1).perform_later(
      user_id: @user.id, book_id: book_id,
      quantity: quantity, time: time
    )

    render_success_data('success', SUCCESS_CODE, data: {job_id: job.provider_job_id, borrow_time: time})
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:balance, :account, :username)
  end
end
