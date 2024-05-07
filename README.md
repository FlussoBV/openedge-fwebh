# flusso webhandler library for openedge

[![CI](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/ci.yaml/badge.svg)](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/ci.yaml)

A databaseless project primarily aimed at providing a standard implementation 

### unittest
unittests are placed next to the classes that are tested and get suffix `_UT`

naming of annotated methods
```
  @Before.
  method public void _before_all_tests():

  @Setup.
  method public void _setup_each_test():
  
  @TearDown.
  method public void _teardown_each_test():
  
  @After.
  method public void _after_all_tests():

  @Test methods follow snka_casing
```
