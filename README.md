# plsql-map
A java-like map construct. This collection type can be used in PL/SQL code also in oracle object types.
My motivation was to provide a way in which i can use a map within an Oracle object types.

The initial code was developed at Airpas Aviation AG, who kindly assented to its publication.

## Installation
Execute the content of the files in the following order:
* T_MAP_ENTRY_TYPE.sql
* T_MAP_ENTRY_BODY.sql
* T_MAP_TABLE_TYPE.sql
* T_MAP_TYPE.sql
* T_MAP_BODY.sql

Note: To update the underlying type t_map_entry the types t_map_table and t_map needs to be deleted.

## Usage
### Simple use
```sql
declare
  l_map t_map := t_map();
begin
  l_map.put('foo', 'bar');
  dbms_output.put_line(l_map.get('foo'));
  -- output: bar

  l_map.remove('foo');
end;
```
### To iterate through the map you can use two ways
#### while
```sql
l_map.iterate(); -- to reset pointer that changed by previous iteration, optional
while l_map.hasNextEntry()
loop
  l_entry := l_map.nextEntry();
  dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());
end loop;
```
#### do-while
```sql
l_entry := l_map.firstEntry(); 
loop
  dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());

  l_entry := l_map.nextEntry();
  exit when not l_map.hasNextEntry();
end loop;
```