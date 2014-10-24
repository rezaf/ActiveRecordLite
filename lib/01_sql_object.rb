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
    output_hash = DBConnection.execute(<<-SQL)
      SELECT
        "#{table_name}".*
      FROM
        "#{table_name}"
    SQL
    
    parse_all(output_hash)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    
  end

  def initialize(params = {})
    
    params.each do |attr_name, value| 
         
      attr_name = attr_name.to_sym
      
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
      
      self.send("#{attr_name}=", value)
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
