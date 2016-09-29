class DbEventSerializer

  def initialize op
    @op = op
  end


  def serialize_view
    id = @op['o']['_id'].to_s.force_encoding("UTF-8")
    person = Test::Person.new(id: id, name: @op['o']['name'], email: @op['o']['email'])

    Test::DbEvent.new(action: Test::DbAction::VIEW, person: person)
  end

  def serialize
    case @op['op']
    when 'i'
      send :serialize_insert
    when 'u'
      send :serialize_update
    when 'd'
      send :serialize_delete
    end
  end

  private
    def serialize_insert
      id = @op['o']['_id'].to_s.force_encoding("UTF-8")
      person = Test::Person.new(id: id, name: @op['o']['name'], email: @op['o']['email'])

      Test::DbEvent.new(action: Test::DbAction::CREATE, person: person)
    end

    def serialize_update
      id = @op['o2']['_id'].to_s.force_encoding("UTF-8")
      name = @op['o']['$set']['name']
      email = @op['o']['$set']['email']
      person = Test::Person.new(id: id, name: name, email: email)

      Test::DbEvent.new(action: Test::DbAction::UPDATE, person: person)
    end

    def serialize_delete
      id = @op['o']['_id'].to_s.force_encoding("UTF-8")
      person = Test::Person.new(id: id)

      Test::DbEvent.new(action: Test::DbAction::DELETE, person: person)
    end

end