require "faraday"
require "json"

class NearTransactionImporter
  BASE_URL = "https://4816b0d3-d97d-47c4-a02c-298a5081c0f9.mock.pstmn.io"
  API_KEY = "SECRET_API_KEY" # Assume this is actual API key. In production, use ENV variable or hide in secrets.

  def self.call
    new.call
  end

  def call
    response = fetch_transactions
    return unless response.success?

    parse_and_store(response.body)
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error("Connection failed: #{e.message}")
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parsing failed: #{e.message}")
  end

  private

  def fetch_transactions
    connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    connection.get("/near/transactions") do |request|
      request.params["api_key"] = API_KEY
    end
  end

  def parse_and_store(body)
    transactions = JSON.parse(body)

    transactions.each do |transaction|
      # Only cares about transactions with transfer actions for this take home implementation
      next unless transfer_transactions?(transaction)

      Transaction.create_with(
        block_hash: transaction["block_hash"],
        time: transaction["time"],
        height: transaction["height"],
        sender: transaction["sender"],
        receiver: transaction["receiver"],
        gas_burnt: transaction["gas_burnt"],
        deposit: extract_deposit(transaction),
        success: transaction["success"],
      ).find_or_create_by(tx_hash: transaction["hash"])
    end
  end

  # Verifies if the action is a transfer and if the transaction already exists in the database.
  def transfer_transactions?(transaction)
    # Improvement: Considering there can be multiple actions, we can iterate through each action
    # and check if any of them is a transfer. But for simplicity of the take home, we'll assume there's only one action.
    transaction.dig("actions", 0, "type")&.downcase == "transfer" && !Transaction.exists?(tx_hash: transaction["tx_hash"])
  end

  def extract_deposit(transaction)
    # Improvement: Adjust for multiple actions
    transaction.dig("actions", 0, "data", "deposit")
  end
end
