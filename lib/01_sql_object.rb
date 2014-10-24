require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        cats
      LIMIT
        1
    SQL
    columns.first.map { |el| el.to_sym }
  end
  
  def self.finalize!
    columns.each do |column|  
      define_method(column) do
        self.attributes[column]
      end
        
      define_method("#{column}=") do |value|
        self.attributes[column] = value
      end
    end  
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || "#{self}".tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    #debugger
    
    params.each do |attr_name, value|    
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
      
      self.class.columns.send(attributes[self.class.columns], value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
