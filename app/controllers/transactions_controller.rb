class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.paginate(page:params[:page],per_page: 20)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:title, :stock, :fee)
  end
end
