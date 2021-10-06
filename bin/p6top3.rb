#! /usr/bin/ruby

# p6top3 - Convert PPM Type P6 (binary) to Type P3 (ascii)

# Last update: Fri Aug  1 10:05:21 JST 2014 by hohno

line = 0
errcnt = 0

while ((line < 3) && (str = STDIN.gets))

  if (str =~ /^#/)
    # STDERR.puts str
    next
  end

  str.chomp!
  line += 1

  if (line == 1)
    if (str == "P6")
      ppmtype = "P6"
    else
      errcnt += 1
      break
    end

  elsif (line == 2)
    if (str =~ /^(\d+) (\d+)$/)
      wh = str
      width = $1.to_i
      height = $2.to_i
    else
      errcnt += 1
      break
    end

  elsif (line == 3)
    if (str =~ /^\d+$/)
      maxval = str
    else
      errcnt += 1
      break
    end

  else
    errcnt += 1
    exit 9
  end
end

if (errcnt > 0)
    STDERR.puts "Header format error."
    exit errcnt
end

# STDERR.puts "TYPE   = " + ppmtype + "\n";
# STDERR.puts "W x H  = " + wh + "\n";
# STDERR.puts "Width  = " + width.to_s + "\n";
# STDERR.puts "Height = " + height.to_s + "\n";
# STDERR.puts "MAXVAL = " + maxval + "\n";

puts "P3"
puts "# stdin"
puts width.to_s + " " + height.to_s
puts maxval

size = width * height * 3

s = 0;
while (s < size)
  body = STDIN.read(width * 3)
  body.unpack("C*").each do |x|
    printf("0x%02x ", x);
  end
  puts("")
  s += body.size
end

if (s != size)
    STDERR.puts "Wrong body size. (" + s.to_s + " != " + size.to_s + ")"
    exit errcnt
end

# puts size
# puts body.size
# puts body.unpack("C*")

# body = STDIN.read()

exit 0

# if 
#
#  head = f.read(8)
#  if head.unpack("CA3C4") == [0x89, "PNG", 0xd, 0xa, 0x1a, 0xa]
#    body = f.read()
#    puts body.unpack("C*")
#    puts "OK!"
#  end
#end
