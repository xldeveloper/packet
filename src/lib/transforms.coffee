bufferize = (array) ->
  buffer = new Buffer(array.length)
  for b, i in array
    buffer[i] = b
  buffer

transforms = exports.transforms =
  str: (encoding, parsing, field, value) ->
    if parsing
      if not (value instanceof Buffer)
        value = bufferize(value)
      if /^ascii$/i.test(encoding)
        # Broken and waiting on [297](http://github.com/ry/node/issues/issue/297).
        # If the top bit is set, it is not ASCII, so we zero the value.
        for i in [0...value.length]
          value[i] = 0 if value[i] & 0x80
        encoding = "utf8"
      length = value.length
      length -= field.terminator.length if field.terminator
      value.toString(encoding, 0, length)
    else
      if field.terminator
        value += field.terminator
      buffer = new Buffer(value, encoding)
      if encoding is "ascii"
        for i in [0...buffer.length]
          buffer[i] = 0 if value.charAt(i) is '\0'
      buffer

  ascii: (parsing, field, value) ->
    transforms.str("ascii", parsing, field, value)

  utf8: (parsing, field, value) ->
    transforms.str("utf8", parsing, field, value)

  pad: (character, length, parsing, field, value) ->
    if not parsing
      while value.length < length
        value = character + value
    value

  atoi: (base, parsing, field, value) ->
    if parsing then parseInt(value, base) else value.toString(base)

  atof: (parsing, field, value) ->
    if parsing then parseFloat(value) else value.toString()
