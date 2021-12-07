module RailsDb
  module Connection

    def connections
      database_configurations[chosen_connection].connection
    end

    def database_configurations
      RailsDb.selectable_databases
    end

    def chosen_connection
      return RailsDb.primary_database if RailsDb.selectable_databases[RailsDb.primary_database.presence].present?
      return RailsDb.selectable_databases.keys[0] unless RailsDb.selectable_databases.blank?

      nil
    end

    def columns
      connections.columns(name)
    end

    def column_properties
      %w(name sql_type null limit precision scale type default)
    end

    def to_param
      name
    end

    def column_names
      columns.collect(&:name)
    end
  end
end
