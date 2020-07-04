class UsersController < ApplicationController
  before_action :set_user, only: %i[borrow edit update destroy]

  def index
    @users = User.order(id: :desc).paginate(page:params[:page],per_page: 20)
  end

  def new
    @user = User.new
  end

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

  def borrow
    book_id = params[:book_id]
    quantity = params[:quantity].to_i

    book = Book.find(book_id)

    if quantity > book.stock
      return render_success_data('the stock is not enough', 20001)
    end

    if @user.balance < quantity * book.fee
      return render_success_data("user's balance is not enough", 20002)
    end

    ActiveRecord::Base.transaction do
      UsersBook.create(user_id: @user.id, book_id: book.id)
      Transaction.lent.create(
        quantity: quantity,
        total_fee: book.fee * quantity,
        user_id: @user.id,
        username: @user.username,
        book_id: book.id,
        book_title: book.title,
        loan_at: Time.zone.now
      )
      @user.update(balance: @user.balance - quantity * book.fee)
      book.update(stock: book.stock - quantity)
    end

    render_success_data('success', 200)
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
