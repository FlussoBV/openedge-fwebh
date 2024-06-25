// test/serialize/tt-with-object.i
define temp-table tt no-undo
  serialize-name "persons"
  field id as int
  field name as char
  field lang as Progress.Lang.Object serialize-name "taal"
  .

