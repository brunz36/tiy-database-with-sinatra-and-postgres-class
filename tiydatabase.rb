require 'sinatra'
require 'pg'
require 'awesome_print'
require 'sinatra/reloader' if development?
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "tiy_database"
)

class Employee < ActiveRecord::Base
  self.primary_key = "id"
end

class Course < ActiveRecord::Base
  self.primary_key = "id"
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  erb :index
end

get '/employees' do
  @employees = Employee.all

  erb :employees
end

get '/show_employee' do
  @employee = Employee.find(params["id"])

  erb :show_employee
end

get '/new_employee' do
  erb :new_employee
end

get '/add_employee' do
  Employee.create(params)

  redirect('/employees')
end

get '/search_employee' do
  search = params["search"]

  @employees = Employee.where("name like ? or github = ? or slack = ?", "%#{search}%", search, search)
  # The $ not working...had to go to ? -- YES!!!!!

  erb :search_employee
end

get '/edit_employee' do
  id = params["id"]

  @employee = Employee.find(params["id"])

  erb :edit_employee
end

get '/append_employee' do
  @employee = Employee.find(params["id"])

  @employee.update_attributes(params)

  erb :show_employee
end

get '/delete_employee' do
  @employee = Employee.find(params["id"])

  @employee.destroy

  redirect to ('/employees')
end

get '/courses' do
  @courses = Course.all

  erb :courses
end

get '/show_course' do
  @course = Course.find(params["id"])

  erb :show_course
end

get '/search_course' do
  search = params["search"]

  @courses = Course.where("name LIKE '%#{search}%'")
  # NOT CORRECT !!!!!!!!!!!!!!!!!!!!!!!

  erb :search_course
end

get '/new_course' do
  erb :new_course
end

get '/add_course' do
  Course.create(params)

  redirect('/courses')
end

get '/edit_course' do
  id = params["id"]

  @course = Course.find(params["id"])

  erb :edit_course
end

get '/append_course' do
  @course = Course.find(params["id"])

  @course.update_attributes(params)

  erb :show_course
end

get '/delete_course' do
  @course = Course.find(params["id"])

  @course.destroy

  redirect to ('/courses')
end
