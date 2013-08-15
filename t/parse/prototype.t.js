#!/usr/bin/env node
require('./proof')(1, function (createParser, equal, deepEqual) {
    var prototype = createParser(), parser
    prototype.packet('packet', 'length: b16, type: b8, name: b8z|utf8()')
    parser = prototype.createParser()
    parser.extract('packet', function (object, read) {
        var expected = {
            length: 258,
            type: 8,
            name: 'ABC' }
        deepEqual(object, expected, 'object read')
    })
    parser.parse([ 0x01, 0x02, 0x08, 0x41, 0x42, 0x43, 0x00 ], 0, 7)
})