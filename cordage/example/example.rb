require_relative '../lib/cordage'
# The rope data structures primary practical purpose is for use as
# storage for text in a text editor.  It's fairly efficient at supporting
# substring replace and insert at a position type of operations.
# This example will demonstrate those two use cases.

editor_buffer = Cordage::Rope.new("")

# Here we could load the whole file in as one string
# But, in that case we'd have a flat rope(single node
# with no depth to the tree).
File.new("example.txt").each do |line|
  editor_buffer << line
end

supervisor = "Gupta"
new_company = "Flick-a-ma-gigger"
old_company = "XYZ Video"
effective = "March 4, 2011"

# replace with range selection
editor_buffer[9..12] = supervisor
editor_buffer[160..171] = new_company

#replace with carat position for some length
editor_buffer[109, 16] = effective
editor_buffer[319, 11] = old_company
editor_buffer[473, 11] = old_company


# insert at carat position
editor_buffer.insert_at(704, "\nAgain, I wish #{old_company} continued success.\n")
editor_buffer.insert_at(766, "Carl Leiby")

puts editor_buffer.root.depth

puts editor_buffer