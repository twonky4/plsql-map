create or replace package body pck_unit_test
is
  procedure assert(l_expected varchar2, l_actual varchar2) is
    COMPARISON_FAILURE exception;
    pragma exception_init(COMPARISON_FAILURE, -20100);
    l_exceptionText varchar2(4000);
  begin
    if l_expected is null and l_actual is not null or l_expected != l_actual then
      l_exceptionText := 'expected:';
      case
        when l_expected is null then
          l_exceptionText := l_exceptionText || 'null';
        else
          l_exceptionText := l_exceptionText || '<' || l_expected || '>';
      end case;
      l_exceptionText := l_exceptionText || ' but was:';
      case
        when l_actual is null then
          l_exceptionText := l_exceptionText || 'null';
        else
          l_exceptionText := l_exceptionText || '<' || l_actual || '>';
      end case;
      raise_application_error(-20100, l_exceptionText);
    end if;
  end assert;

  procedure assertFalse(l_actual boolean) is
    l_text varchar(5);
  begin
    case
      when l_actual then
        l_text := 'true';
      when not l_actual then
        l_text := 'false';
      else
        l_text := null;
    end case;
    assert('false', l_text);
  end assertFalse;

  procedure assertTrue(l_actual boolean) is
  begin
    assertFalse(not l_actual);
  end assertTrue;

  procedure shouldGetValueForOneEntry is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    assert('value1', l_map.get('key1'));
  end shouldGetValueForOneEntry;

  procedure shouldGetNullOnEmpty is
    l_map t_map := t_map();
  begin
    assert(null, l_map.get('key1'));
  end shouldGetNullOnEmpty;

  procedure shouldGetValueForMoreEntries is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');

    assert('value1', l_map.get('key1'));
    assert('value2', l_map.get('key2'));
  end shouldGetValueForMoreEntries;

  procedure shouldGetNullValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', null);

    assert(null, l_map.get('key1'));
  end shouldGetNullValue;

  procedure shouldOverrideValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');
    l_map.put('key1', 'value2');

    assert('value2', l_map.get('key1'));
  end shouldOverrideValue;

  procedure shouldReturnOverwrittenValue is
    l_map t_map := t_map();
  begin
    assert(null, l_map.put('key1', 'value1'));
    assert('value1', l_map.put('key1', 'value2'));
    assert('value2', l_map.get('key1'));
  end shouldReturnOverwrittenValue;

  procedure shouldRemoveValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');

    l_map.remove('key1');

    assertFalse(l_map.containsKey('key1'));
  end shouldRemoveValue;

  procedure shouldReturnRemovedValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    assert('value1', l_map.remove('key1'));
  end shouldReturnRemovedValue;

  procedure shouldClearMap is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    l_map.clear();

    assertFalse(l_map.containsKey('key1'));
  end shouldClearMap;

  procedure shouldContainsKey is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    assertTrue(l_map.containsKey('key1'));
  end shouldContainsKey;

  procedure shouldNotContainsKey is
    l_map t_map := t_map();
  begin
    assertFalse(l_map.containsKey('key1'));
  end shouldNotContainsKey;

  procedure shouldReturnEntryCount is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key1', 'value1a');

    assert('2', l_map.entryCount());
  end shouldReturnEntryCount;

  procedure shouldBeEmpty is
    l_map t_map := t_map();
  begin
    assertTrue(l_map.isEmpty());
  end shouldBeEmpty;

  procedure shouldBeNotEmpty is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    assertFalse(l_map.isEmpty());
  end shouldBeNotEmpty;

  procedure test is
  begin
    shouldGetValueForOneEntry();
    shouldGetNullOnEmpty();
    shouldGetValueForMoreEntries();
    shouldGetNullValue();
    shouldOverrideValue();
    shouldReturnOverwrittenValue();
    shouldRemoveValue();
    shouldReturnRemovedValue();
    shouldClearMap();
    shouldContainsKey();
    shouldNotContainsKey();
    shouldReturnEntryCount();
    shouldBeEmpty();
    shouldBeNotEmpty();

    dbms_output.put_line('all test successful');
  end test;
end;
/
