class Heap
  #NOTE: Element indices are 1-based. This allows for easy calculation of an element's parent, left/right child.
  attr_accessor :heap_data

  # min-heap or max-heap
  attr_accessor :heap_property

  def initialize(heap_property = :min)
    @heap_data = []
    @heap_property = heap_property_proc(heap_property)
  end

  def root
    @heap_data.first
  end

  def insert(new_item)
    # Insert new element in the last leaf of the heap tree
    @heap_data << new_item

    # Heapify
    siftup(@heap_data.length)
  end

  def pop_root
    root_value = root

    # swap root with last element and siftdown
    swap(1, @heap_data.length)
    @heap_data.pop

    siftdown
    root_value
  end

private
  def heap_property_proc(property)
    if property == :max
      Proc.new {|n,m| n >= m}
    else
      Proc.new {|n,m| n <= m}
    end
  end

  def value(pos)
    # Need to convert 1-based indexing to 0-based indexing
    @heap_data[pos-1]
  end

  def set(pos, new_item)
    @heap_data[pos-1] = new_item
  end

  def siftup(starting_pos)
    pos = starting_pos

    # return if starting at the root
    until pos == 1
      p = parent(pos)

      return if @heap_property.call(value(p), value(pos))

      swap(p, pos)
      pos = p
    end
  end

  def siftdown
    pos = 1
    last = @heap_data.length

    while true
      lc = left_child(pos)
      rc = right_child(pos)
      return if lc > last

      child = lc
      child = rc if rc <= last && @heap_property.call(value(rc), value(lc))

      return if @heap_property.call(value(pos), value(child))

      swap(pos, child)
      pos = child
    end
  end

  def parent(pos)
    pos / 2
  end

  def left_child(pos)
    pos * 2
  end

  def right_child(pos)
    pos * 2 + 1
  end

  def swap(posOne, posTwo)
    tmp = value(posOne)
    set(posOne, value(posTwo))
    set(posTwo, tmp)
  end
end
