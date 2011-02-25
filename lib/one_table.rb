
class OneTable

  def initialize(rows = [], opts = {})
    @rows = rows
    @headers = opts[:headers]
  end
  def headers=(*values)
    @headers = [values].flatten
  end
  def headers
    @headers ||= []
  end
  def append_row(value)
    rows << value
  end
  def rows
    @rows ||= []
  end
  def row_size
    rows.size
  end
  def hash_rows
    @rows.map { |row| row_hash(row, headers) }
  end
  def actions
    @actions ||= []
  end
  def execute_actions!
    @action_headers = []
    actions.each do |action|
      action.each do |key, proc|
        @action_headers << key
      end
    end
    action_key_to_index = {}
    @action_headers.each_with_index do |key, index|
      action_key_to_index[key] = index
    end
    headers_size = headers.size
    rows.map do |row|
      rh = row_hash(row, headers)
      actions.each do |action|
        action.each do |key, proc|
          row[headers_size + action_key_to_index[key]] = rh[key] = proc.call(rh)
        end
      end
      row
    end
  end
  private
  def row_hash(row, headers)
    row = adjust_row(row, headers.size)
    Hash[*[headers, row].transpose.flatten]
  end
  def adjust_row(array, size)
    if array.size == size
      array
    elsif array.size > size
      array[0, size]
    else # array.size < size
      array + [nil] * (size - array.size)
    end
  end
end

