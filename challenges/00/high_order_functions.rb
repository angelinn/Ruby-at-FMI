def complement(f)
  lambda { |n| not f.call(n) }
end

def compose(f, g)
  lambda { |*args| f.call(g.call(*args)) }
end
