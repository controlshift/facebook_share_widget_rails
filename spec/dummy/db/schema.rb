# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120628021206) do

  create_table "facebook_share_widget_shares", :force => true do |t|
    t.string   "user_facebook_id"
    t.string   "friend_facebook_id"
    t.string   "url"
    t.text     "message"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "facebook_share_widget_shares", ["user_facebook_id", "friend_facebook_id", "url"], :name => "unique_share", :unique => true

end
