module Model
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,           type: String
    field :email,          type: String
  end
end