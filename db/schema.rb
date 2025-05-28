# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_05_28_202245) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auditoria", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "acao"
    t.text "detalhes"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_auditoria_on_user_id"
  end

  create_table "contas_bancarias", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "numero_conta", null: false
    t.string "agencia", null: false
    t.integer "saldo", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["numero_conta"], name: "index_contas_bancarias_on_numero_conta", unique: true
    t.index ["user_id"], name: "index_contas_bancarias_on_user_id"
  end

  create_table "transacoes", force: :cascade do |t|
    t.bigint "conta_origem_id", null: false
    t.bigint "conta_destino_id", null: false
    t.integer "valor", null: false
    t.string "descricao", null: false
    t.datetime "data_hora", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conta_destino_id"], name: "index_transacoes_on_conta_destino_id"
    t.index ["conta_origem_id"], name: "index_transacoes_on_conta_origem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome", null: false
    t.string "email", null: false
    t.string "cpf", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "auditoria", "users"
  add_foreign_key "contas_bancarias", "users"
  add_foreign_key "transacoes", "contas_bancarias", column: "conta_destino_id"
  add_foreign_key "transacoes", "contas_bancarias", column: "conta_origem_id"
end
