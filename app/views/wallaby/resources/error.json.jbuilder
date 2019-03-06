json.error do
  json.code @code
  if @code < 500 && @exception.present?
    json.message @exception.message
  else
    json.message t("json_errors.#{@symbol}")
  end
end
