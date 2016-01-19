create or replace type t_map as object (
/**
 * An object that maps keys to values. A map cannot contain duplicate keys; each key can map to
 * at most one value. It can iterate through the map. The iteration order of a map is defined as
 * the elements are added.
 *
 * Simple use:
 *   declare
 *     l_map t_map := t_map();
 *   begin
 *     l_map.put('foo', 'bar');
 *     dbms_output.put_line(l_map.get('foo'));
 *     -- output: bar
 *
 *     l_map.remove('foo');
 *   end;
 *
 * To iterate through the map you can use two ways:
 * 1) while:
 *    l_map.iterate(); -- to reset pointer that changed by previous iteration, optional
 *    while l_map.hasNextEntry()
 *    loop
 *      l_entry := l_map.nextEntry();
 *      dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());
 *    end loop;
 *
 * 2) do-while:
 *    l_entry := l_map.firstEntry();
 *    loop
 *      dbms_output.put_line(l_entry.getKey() || ' -> ' || l_entry.getValue());
 *
 *      exit when not l_map.hasNextEntry();
 *      l_entry := l_map.nextEntry();
 *    end loop;
 *
 * See object types: t_map_table, t_map_entry
 */

  m_map t_map_table,
  m_iterationCounter integer,

  constructor function t_map return self as result,

  /**
   * Returns the value to which the specified key is mapped, or null if this map contains no
   * mapping for the key.
   */
  member function get(pi_key varchar2) return varchar2,

  /**
   * Associates the specified value with the specified key in this map. If the map previously
   * contained a mapping for the key, the old value is replaced by the specified value.
   */
  member procedure put(pi_key varchar2, pi_value varchar2),

  /**
   * Associates the specified value with the specified key in this map. If the map previously
   * contained a mapping for the key, the old value is replaced by the specified value. Returns the
   * value to which this map previously associated the key, or null if the map contained no mapping
   * for the key.
   */
  member function put(self in out t_map, pi_key varchar2, pi_value varchar2) return varchar2,

  /**
   * Removes the mapping for a key from this map if it is present.
   */
  member procedure remove(pi_key varchar2),

  /**
   * Removes the mapping for a key from this map if it is present. Returns the value to which this
   * map previously associated the key, or null if the map contained no mapping for the key.
   */
  member function remove(self in out t_map, pi_key varchar2) return varchar2,

  /**
   * Removes all of the mappings from this map.
   */
  member procedure clear,

  /**
   * Returns true if this map contains a mapping for the specified key, otherwise false.
   */
  member function containsKey(pi_key varchar2) return boolean,

  /**
   * Returns true if this map maps one or more keys to the specified value.
   */
  member function containsValue(pi_value varchar2) return boolean,

  /**
   * Returns the number of key-value mappings in this map.
   */
  member function entryCount return number,

  /**
   * Returns true if this map contains no key-value mappings.
   */
  member function isEmpty return boolean,

  /**
   * Returns the first element of this map, or  null if this map is empty. Re-/Inialize iteration
   * counter, so functions nextEntry() and hasNextEntry() point to the the second entry.
   */
  member function firstEntry(self in out t_map) return t_map_entry,

  /**
   * Returns the next entry in the map or null if no more entries available. This function may be
   * called repeatedly to iterate through the map. To begin from the first map entry again call
   * function iterate().
   */
  member function nextEntry(self in out t_map) return t_map_entry,

  /**
   * Iterate to the next entry. This function may be called repeatedly to iterate through the map.
   * To begin from the first map entry again call function iterate().
   */
  member procedure nextEntry,

  /**
   * Re-/Inialize iteration counter. So functions nextEntry() and hasNextEntry() will point to first
   * entry of the map.
   */
  member procedure iterate,

  /**
   * Returns true if for the actual map iteration another entry is available. To begin from the
   * first map entry again call function iterate().
   */
  member function hasNextEntry return boolean,

  /**
   * Removes from the map the last element returned by the methode nextEntry(). This method can be
   * called only once per call to nextEntry(). If iteration is not initialed the first entry will
   * be removed.
   */
  member procedure removeCurrent,

  /**
   * Removes from the map the last element returned by the methode nextEntry(). This method can be
   * called only once per call to nextEntry(). Returns the removed entry or null, if entry already
   * deleted. If iteration is not initialed the first entry will be removed.
   */
  member function removeCurrent(self in out t_map) return t_map_entry,

  /**
   * Replaces the value corresponding to this entry with the specified value. If the current entry
   * already deleted by method removeCurrent(), nothing happens.
   */
  member procedure setCurrentValue(pi_value varchar2),

  /**
   * Replaces the value corresponding to this entry with the specified value. If the current entry
   * already deleted by method removeCurrent(), nothing happens. Returns the value that was
   * assigned before.
   */
  member function setCurrentValue(self in out t_map, pi_value varchar2) return varchar2
);
/
