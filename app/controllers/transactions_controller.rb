class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def import
    # Calls the service to import transactions
    NearTransactionImporter.call

    redirect_to transactions_path
  end
end
