class ContaBancaria < ActiveRecord::Migration[7.2]
  def change
    create_table :contas_bancarias do |t|
      t.references :user, null: false, foreign_key: true
      t.string :numero_conta, null: false, index: { unique: true }
      t.string :agencia, null: false
      t.integer :saldo, precision: 15, scale: 2, default: 0, null: false
      t.timestamps
    end
  end
end
