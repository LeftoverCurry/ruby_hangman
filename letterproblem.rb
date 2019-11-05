word = 'hello'
arr = word.split ''
newarr = []

arr.each_with_index do |letter, index| 
  if letter == "l" 
    arr.delete_at(index) 
  else newarr << letter 
  end
end

arr = newarr
`say "#{arr}"`


newarr = []
      @magic_word.each_with_index do |l, index| 
        if l == letter
        @magic_word.delete_at(index) 
        else 
          newarr << l 
          @magic_word = newarr
          binding.pry
        end