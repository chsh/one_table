require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe OneTable do
  it 'should hold table data inside.' do
    os1 = OneTable.new([['a', 'b', 'c']], headers: [:h3, :h1, :h2])
    os1.row_size.should == 1
    os1.actions.should == []
    os1.headers.should == [:h3, :h1, :h2]
    os2 = OneTable.new
    os2.rows.should == []
    os2.rows << ['a', 'b', 'c']
    os2.rows << ['x', 'y', 'z']
    os2.headers =  [:h3, :h1, :h2]
    os2.headers.should == [:h3, :h1, :h2]
    os2.hash_rows.should == [
        {h3: 'a', h1: 'b', h2: 'c'},
        {h3: 'x', h1: 'y', h2: 'z'},
    ]
  end
  it 'should evaluate actions.' do
    os = OneTable.new([['a', 'b', 'c']], headers: [:h3, :h1, :h2])
    os.actions << {x1: lambda { |row_hash|
      row_hash[:h3] + ':' + row_hash[:h2]
    }}
    os.actions << {a2: lambda { |row_hash|
      row_hash[:x1] * 3
    }}
    os.execute_actions!
    os.rows[0].should == [
        'a', 'b', 'c', 'a:c', 'a:ca:ca:c'
    ]
  end
  it 'should hold table data inside.' do
    os = OneTable.new([['a', 'b', 'c']], headers: [:h3, :h1, :h2])
    os.row_size.should == 1
    os.actions.should == []
    os.actions << {x1: lambda { |row_hash|
      row_hash[:h3] + ':' + row_hash[:h2]
    }}
    os.actions << {a2: lambda { |row_hash|
      row_hash[:x1] * 3
    }}
    os.execute_actions!
    os.rows[0].should == [
        'a', 'b', 'c', 'a:c', 'a:ca:ca:c'
    ]
  end
end
