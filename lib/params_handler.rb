def params_handler(*param) # заменяет в указанных параметрах ' ' на '_'
    param = params.keys & param
    param.size.times { |index| params[param[index]].gsub!(' ', '_') unless param[index] =~ /  / }
end