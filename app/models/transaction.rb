class Transaction < ApplicationRecord
    # All columns from the Transaction is expected to be present under normal circumstances
    validates :time, presence: true
    validates :height, presence: true
    validates :tx_hash, presence: true, uniqueness: true # Ensure no duplicate tx_hashes
    validates :block_hash, presence: true, uniqueness: true # Ensure no duplicate block_hashes
    validates :sender, presence: true
    validates :receiver, presence: true
    validates :gas_burnt, presence: true
    validates :deposit, presence: true
    validates :success, presence: true
end
