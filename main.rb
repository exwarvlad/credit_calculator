require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require_relative 'lib/params_handler'

helpers Sinatra::Param

get '/' do
  erb :index, :locals => {:name => params[:name]}
end

post '/result' do
  params_handler('percent', 'credit_sum', 'term')
  params_clone = params.clone
  MAX_CREDIT = 9999999999999999999999999
  MAX_PERCENT = 9999999999999999999999999
  param :percent, Float, min: 0, max: MAX_PERCENT, blank: false
  param :credit_sum, Float, min: 0, max: MAX_CREDIT, blank: false
  param :term, Integer, min: 1, max: 1200, blank: false
  @params = params_clone
  erb :result, :locals => {:params => request.POST}
end
