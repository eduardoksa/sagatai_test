class Transacao < ActiveRecord::Migration[7.2]
  def change
    create_table :transacoes do |t|
      t.references :conta_origem, null: false, foreign_key: { to_table: :contas_bancarias }
      t.references :conta_destino, null: false, foreign_key: { to_table: :contas_bancarias }
      t.integer :valor, precision: 15, scale: 2, null: false
      t.string :descricao, null: false
      t.datetime :data_hora, null: false
      t.timestamps
    end
  end
end
