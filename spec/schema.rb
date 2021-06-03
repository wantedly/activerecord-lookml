ActiveRecord::Schema.define(version: 2021_05_26_103300) do
  create_table "pulse_onboarding_statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.integer "manager_tutorial_state"
    t.integer "member_tutorial_state"
    t.string "session_id"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
