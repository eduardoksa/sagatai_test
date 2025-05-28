class CreateAuditoria < ActiveRecord::Migration[7.2]
  def change
    create_table :auditoria do |t|
      t.references :user, null: false, foreign_key: true
      t.string :acao
      t.text :detalhes
      t.string :ip

      t.timestamps
    end
  end
end
