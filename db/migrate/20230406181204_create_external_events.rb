class CreateExternalEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :external_events do |t|
      t.references :calendar, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.references :event, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.string :external_id

      t.timestamps
    end
  end
end
