test "test javap fmt" {
    let simple = @fs.read_file_to_bytes("test-data/Simple.class")
    let buf = @bytebuf.make_unpooled_from_bytes(simple)
    println(buf.remaining())
    let parsed = @parser.parse_class(buf)
    println(@javap.fmt(parsed))
}