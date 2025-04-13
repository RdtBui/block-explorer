class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.datetime :time
      t.integer :height
      t.string :tx_hash
      t.string :block_hash
      t.string :sender
      t.string :receiver
      t.bigint :gas_burnt
      t.string :deposit
      t.boolean :success

      t.timestamps
    end
    add_index :transactions, :tx_hash
    add_index :transactions, :block_hash
  end
end
