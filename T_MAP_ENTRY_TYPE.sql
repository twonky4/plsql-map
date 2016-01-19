create or replace type t_map_entry as object(
/**
 * A map entry (key-value pair). These objects are valid only for the duration of the iteration;
 * changing values has no effect to any entry of the a map. To change the value of the current
 * object call t_map.setCurrentValue().
 *
 * See object types: t_map, t_map_table
 */

  m_key varchar2(32767),
  m_value varchar2(32767),

  /**
   * Returns the key corresponding to this entry.
   */
  member function getKey return varchar2,

  /**
   * Returns the value corresponding to this entry.
   */
  member function getValue return varchar2
);
/
