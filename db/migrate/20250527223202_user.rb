class User < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :nome, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :cpf, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
