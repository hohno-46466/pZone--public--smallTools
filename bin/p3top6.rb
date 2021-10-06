#! /usr/bin/ruby

# p3top6 - Convert PPM Type P3 (ascii)  to Type P6 (binary)

# Last update: Fri Aug  1 10:05:21 JST 2014 by hohno

line = 0
errcnt = 0
ppmtype=""

while ((line < 3) && (str = STDIN.gets))

  if (str =~ /^#/)
    # STDERR.puts str
    next
  end

  str.chomp!
  line += 1

  if (line == 1)
    if (str == "P3")
      ppmtype = "P3"
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

# STDERR.puts "TYPE   = " + ppmtype + "\n";
# STDERR.puts "Width  = " + width.to_s + "\n";
# STDERR.puts "Height = " + height.to_s + "\n";
# STDERR.puts "MAXVAL = " + maxval + "\n";

if (errcnt > 0)
    STDERR.puts "Header format error."
    exit errcnt
end

puts "P6"
puts "# stdin"
puts width.to_s + " " + height.to_s
puts maxval

size = width * height * 3

s = 0;
while (s < size)
  array = []
  unless body = STDIN.gets
    break
  end
  body.chomp!
  body.strip!
  body.split(" ").each do |x|
    array << x.hex
    s += 1;
  end
  STDOUT.write(array.pack("C*"))
end

if (s != size)
    STDERR.puts "Wrong body size. (" + s.to_s + " != " + size.to_s + ")"
    exit errcnt
end

exit 0

