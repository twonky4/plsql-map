create or replace package body pck_unit_test
is
  procedure fail(l_exceptionText varchar2) is
    COMPARISON_FAILURE exception;
    pragma exception_init(COMPARISON_FAILURE, -20100);
  begin
    raise_application_error(-20100, l_exceptionText);
  end fail;

  procedure fail is
  begin
    fail(null);
  end fail;

  procedure assert(l_expected varchar2, l_actual varchar2) is
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
      fail(l_exceptionText);
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

  procedure shouldContainsNullKey is
    l_map t_map := t_map();
  begin
    l_map.put(null, 'value1');

    assertTrue(l_map.containsKey(null));
  end shouldContainsNullKey;

  procedure shouldNotContainsNullKey is
    l_map t_map := t_map();
  begin
    assertFalse(l_map.containsKey(null));
  end shouldNotContainsNullKey;

  procedure shouldContainsValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');

    assertTrue(l_map.containsValue('value1'));
  end shouldContainsValue;

  procedure shouldNotContainsValue is
    l_map t_map := t_map();
  begin
    assertFalse(l_map.containsValue('value1'));
  end shouldNotContainsValue;

  procedure shouldContainsNullValue is
    l_map t_map := t_map();
  begin
    l_map.put('key1', null);

    assertTrue(l_map.containsValue(null));
  end shouldContainsNullValue;

  procedure shouldNotContainsNullValue is
    l_map t_map := t_map();
  begin
    assertFalse(l_map.containsValue(null));
  end shouldNotContainsNullValue;

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

  procedure shouldGetValueForNullKey is
    l_map t_map := t_map();
  begin
    l_map.put(null, 'value1');

    assert('value1', l_map.get(null));
  end shouldGetValueForNullKey;

  procedure shouldGetFirstValue is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');

    l_entry := l_map.firstEntry();

    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());
  end shouldGetFirstValue;

  procedure shouldGetFirstValueAfterRemove is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');

    l_map.remove('key1');

    l_entry := l_map.firstEntry();

    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());
  end shouldGetFirstValueAfterRemove;

  procedure shouldIterate is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());

    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());

    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key3', l_entry.getKey());
    assert('value3', l_entry.getValue());
  end shouldIterate;

  procedure shouldIterateWithRemoveNext is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    l_map.nextEntry();
    l_map.remove('key2');
    l_entry := l_map.nextEntry();

    assert('key3', l_entry.getKey());
    assert('value3', l_entry.getValue());
  end shouldIterateWithRemoveNext;

  procedure shouldIterateWithRemovePrev is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    l_map.nextEntry();
    l_map.remove('key1');
    l_entry := l_map.nextEntry();

    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());
  end shouldIterateWithRemovePrev;

  procedure shouldResetIteration is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());

    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());

    l_map.iterate();
    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());
  end shouldResetIteration;

  procedure shouldRemoveWhileIteration is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());

    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());
    l_map.removeCurrent();

    assertTrue(l_map.hasNextEntry());
    l_map.nextEntry();
    l_entry := l_map.removeCurrent();
    assert('key3', l_entry.getKey());
    assert('value3', l_entry.getValue());

    assertFalse(l_map.containsKey('key2'));
    assertFalse(l_map.containsKey('key3'));
  end shouldRemoveWhileIteration;

  procedure shouldRemoveCurrentNotInitial is
    l_map t_map := t_map();
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.removeCurrent();
    assertFalse(l_map.containsKey('key1'));
  end shouldRemoveCurrentNotInitial;

  procedure shouldRemoveNothingOnEmptyMap is
    l_map t_map := t_map();
  begin
    l_map.removeCurrent();
  end shouldRemoveNothingOnEmptyMap;

  procedure shouldRemoveTwiceButDoNothing is
    l_map t_map := t_map();
    l_entry t_map_entry;
  begin
    l_map.put('key1', 'value1');
    l_map.put('key2', 'value2');
    l_map.put('key3', 'value3');

    l_map.iterate();
    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key1', l_entry.getKey());
    assert('value1', l_entry.getValue());

    assertTrue(l_map.hasNextEntry());
    l_entry := l_map.nextEntry();
    assert('key2', l_entry.getKey());
    assert('value2', l_entry.getValue());
    l_map.removeCurrent();

    assertTrue(l_map.hasNextEntry());
    l_map.nextEntry();
    l_entry := l_map.removeCurrent();
    assert('key3', l_entry.getKey());
    assert('value3', l_entry.getValue());
    l_entry := l_map.removeCurrent();

    if l_entry is not null then
      fail();
    end if;

    assertFalse(l_map.containsKey('key2'));
    assertFalse(l_map.containsKey('key3'));
  end shouldRemoveTwiceButDoNothing;

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
    shouldContainsNullKey();
    shouldNotContainsNullKey();
    shouldContainsValue();
    shouldNotContainsValue();
    shouldContainsNullValue();
    shouldNotContainsNullValue();
    shouldReturnEntryCount();
    shouldBeEmpty();
    shouldBeNotEmpty();
    shouldGetValueForNullKey();
    shouldGetFirstValue();
    shouldGetFirstValueAfterRemove();
    shouldIterate();
    shouldIterateWithRemoveNext();
    shouldIterateWithRemovePrev();
    shouldResetIteration();
    shouldRemoveWhileIteration();
    shouldRemoveCurrentNotInitial();
    shouldRemoveNothingOnEmptyMap();
    shouldRemoveTwiceButDoNothing();

    dbms_output.put_line('all test successful');
  end test;
end;
/
