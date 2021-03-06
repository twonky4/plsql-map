# PL/SQL Map
A java-like map construct. This collection type can be used in PL/SQL code also in oracle object types.
My motivation was to provide a way in which i can use an iterable map within an Oracle object types.

The initial code was developed at Airpas Aviation AG, who kindly assented to its publication.
## Installation
Execute the content of the files in the following order:
* T_MAP_ENTRY_TYPE.sql
* T_MAP_ENTRY_BODY.sql
* T_MAP_TABLE_TYPE.sql
* T_MAP_TYPE.sql
* T_MAP_BODY.sql

Note: To update the underlying type `t_map_entry` the types `t_map_table` and `t_map` needs to be deleted.
## Usage
### Simple use
```sql
declare
  l_map t_map := t_map();
begin
  -- fill
  l_map.put('foo', 'bar');

  -- read
  dbms_output.put_line(l_map.get('foo'));
  -- output: bar

  -- delete
  l_map.remove('foo');
end;
```
### Using in queries
```sql
declare
  l_map t_map := t_map();
  l_value varchar2(32767);
begin
  l_map.put('key1', 'value1');
  l_map.put('key2', 'value2');

  -- use asTable() function with table()
  select m_value
  into   l_value
  from   table(l_map.asTable())
  where  m_key = 'key2';

  dbms_output.put_line('value for key2 is '|| l_value);

  -- output: value for key2 is value2
end;
```
### To iterate through the map you can use three ways
#### while
```sql
declare
  l_map t_map := t_map();
  l_entry t_map_entry;
begin
  l_map.put('foo', 'bar');
  l_map.put('ping', 'pong');

  l_map.iterate(); -- to reset pointer that changed by previous iteration, optional
  while l_map.hasNextEntry()
  loop
    l_entry := l_map.nextEntry();
    dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());
  end loop;

  -- output: foo -> bar
  -- output: ping -> pong
end;
```
#### do-while
```sql
declare
  l_map t_map := t_map();
  l_entry t_map_entry;
begin
  l_map.put('foo', 'bar');
  l_map.put('ping', 'pong');

  l_entry := l_map.firstEntry();
  loop
    dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());

    exit when not l_map.hasNextEntry();
    l_entry := l_map.nextEntry();
  end loop;

  -- output: foo -> bar
  -- output: ping -> pong
end;
```
#### enhanced loop using query
```sql
declare
  l_map t_map := t_map();
  l_entry t_map_entry;
begin
  l_map.put('foo', 'bar');
  l_map.put('ping', 'pong');

  for l_entry in (
    select m_key, m_value
    from   table(l_map.asTable())
  ) loop
    dbms_output.put_line(l_entry.m_key || ' -> ' || l_entry.m_value);
  end loop;

  -- output: foo -> bar
  -- output: ping -> pong
end;
```
### access while iteration
```sql
declare
  l_map t_map := t_map();
  l_entry t_map_entry;
begin
  l_map.put('foo', 'bar');
  l_map.put('ping', 'test');
  l_map.put('pong', 'test');

  l_map.iterate();
  while l_map.hasNextEntry()
  loop
    l_entry := l_map.nextEntry();
    if l_entry.getValue() = 'test' then
      l_map.removeCurrent();
    else
      l_map.setCurrentValue('fighters');
    end if;
  end loop;

  -- entries 2 & 3 deleted
  -- entries 1 changed
end;
```
### additional check functions
```sql
declare
  l_map t_map := t_map();
begin
  l_map.put('ping', 'pong');

  -- contains key
  if l_map.containsKey('ping') then
    dbms_output.put_line('key ping exists');
  end if;

  -- contains value
  if l_map.containsValue('pong') then
    dbms_output.put_line('value pong exists');
  end if;

  -- is empty
  if not l_map.isEmpty() then
    dbms_output.put_line('map is not empty');
  end if;

  -- entry count
  dbms_output.put_line(l_map.entryCount() || ' map entries exists');

  -- output:
  -- key ping exists
  -- value pong exists
  -- map is not empty
  -- 1 map entries exists
end;
```
## Test
In order to make the unit tests runnable you need to execute the scripts `PCK_UNIT_TEST.sql` and `PCK_UNIT_TEST_BODY.sql`. The tests can be started with by following the command:
```sql
begin
  pck_unit_test.test();
  -- should output: all test successful
end;
```
