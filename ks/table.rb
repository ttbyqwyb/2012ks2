#!/usr/bin/ruby

def ary_to_table( ary )
  html = '<table border="1" cellpadding="10" cellspacing="0">' + "\n"
  ary.each do |row|
    html += "<tr>\n"
    row.each do |data|
      html += "<td>" + data.to_s + "</td>\n"
    end
    html += "</tr>\n"
  end
  html += "</tr>\n</table>\n"
  return html
end

def hashary_to_ary( key, hashary ) #[{...}, {...}, ..., {...}] to [[...], [...], ..., [...]]
  if key.nil?
    []
  else
    ary = [key]
    hashary.each do |h|
      a = []
      key.each do |k|
        a << h[k]
      end
      ary << a
    end
    return ary
  end
end
