class BooksController < ApplicationController
  before_action :set_book, only: %i[income detail edit update destroy]

  def index
    @books = Book.paginate(page:params[:page],per_page: 20)
  end

  def new
    @book = Book.new
  end

  def detail; end

  def income
    start_at = params[:start_at]
    end_at = params[:end_at] || Time.zone.now

    trans = Transaction.lent.recorded.where(book_id: @book.id)
    if start_at.present?
      income = trans.where('loan_at BETWEEN ? AND ?', start_at, end_at).sum(:total_fee)
    else
      income = @book.income
    end

    render_success_data('success', SUCCESS_CODE, {income: income})
  end

  def show
    redirect_to books_path, notice: 'edit success.'
  end

  def edit; end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :stock, :fee, :total_stock)
  end
end
