module RailsDb
  module Connection

    def connections
      connection = database_configurations[chosen_connection] || database_configurations
      ActiveRecord::Base.establish_connection(connection).connection
    end

    def database_configurations
      Rails.application.config.database_configuration[Rails.env]
    end

    def chosen_connection
      return RailsDb.primary_database if (RailsDb.selectable_databases.include?(RailsDb.primary_database.presence))
      return RailsDb.selectable_databases[0] unless RailsDb.selectable_databases.blank?

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
