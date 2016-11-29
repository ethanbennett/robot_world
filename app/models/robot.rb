require 'sqlite3'

class Robot
  attr_reader :name, :description, :id

  def initialize(robot_params)
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @name = robot_params["name"]
    @description = robot_params["description"]
    @id = robot_params["id"] if robot_params["id"]
  end

  def create
    @database.execute("INSERT INTO robots (name, description) VALUES (?,?);", @name, @description)
  end

  def self.all
    robots = database.execute("SELECT * FROM robots")
      robots.map do |robot|
        Robot.new(robot)
    end
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def self.find(id)
    robot = database.execute("SELECT * FROM robots WHERE id = ?", id)[0..2].first
    Robot.new(robot)
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots
                      SET name = ?,
                          description = ?
                      WHERE id = ?;",
                      robot_params["name"],
                      robot_params["description"],
                      id)
    Robot.find(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots
                      WHERE id = ?;", id)
  end

end
