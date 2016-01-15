create or replace type body t_map is
  constructor function t_map
  return self as result is
  begin
    self.clear();

    return;
  end;

  member function get(pi_key varchar2) return varchar2 is
    l_i number;
  begin
    l_i := m_map.first();
    while (l_i is not null)
    loop
      if m_map(l_i).m_key = pi_key then
        return m_map(l_i).m_value;
      end if;

      l_i := m_map.next(l_i);
    end loop;

    return null;
  end;

  member procedure put(pi_key varchar2, pi_value varchar2) is
    l_new_entry t_map_entry := t_map_entry(pi_key, pi_value);
  begin
    remove(pi_key);

    m_map := m_map multiset union t_map_table(l_new_entry);
  end;

  member function put(self in out t_map, pi_key varchar2, pi_value varchar2) return varchar2 is
    l_last_value varchar2(32767) := get(pi_key);
  begin
    self.put(pi_key, pi_value);

    return l_last_value;
  end;

  member procedure remove(pi_key varchar2) is
    l_i number;
  begin
    -- search and delete exists value
    l_i := m_map.first();
    while (l_i is not null)
    loop
      if m_map(l_i).m_key = pi_key then
        m_map.delete(l_i);
        exit;
      end if;

      l_i := m_map.next(l_i);
    end loop;
  end;

  member function remove(self in out t_map, pi_key varchar2) return varchar2 is
    l_last_value varchar2(32767) := get(pi_key);
  begin
    self.remove(pi_key);

    return l_last_value;
  end;

  member procedure clear is
  begin
    m_map := t_map_table();
    m_iterationCounter := -1;
  end;

  member function containsKey(pi_key varchar2) return boolean is
    l_i number;
  begin
    l_i := m_map.first();
    while (l_i is not null)
    loop
      if m_map(l_i).m_key = pi_key then
        return true;
      end if;

      l_i := m_map.next(l_i);
    end loop;

    return false;
  end;

  member function entryCount return number is
  begin
    return m_map.count;
  end;

  member function isEmpty return boolean is
  begin
    case
      when m_map.count = 0 then return true;
      else return false;
    end case;
  end;

  member function firstEntry(self in out t_map) return t_map_entry is
  begin
    m_iterationCounter := self.m_map.first();

    if m_iterationCounter is null then
      return null;
    end if;

    return m_map(m_iterationCounter);
  end;

  member function nextEntry(self in out t_map) return t_map_entry is
  begin
    if m_iterationCounter = -1 then
      m_iterationCounter := self.m_map.first();
    else
      m_iterationCounter := self.m_map.next(m_iterationCounter);
    end if;

    if m_iterationCounter is null then
      return null;
    end if;

    return m_map(m_iterationCounter);
  end;

  member procedure iterate is
  begin
    m_iterationCounter := -1;
  end;

  member function hasNextEntry return boolean is
    l_iterationCounter integer := m_iterationCounter;
  begin
    if l_iterationCounter = -1 then
      l_iterationCounter := self.m_map.first();
    else
      l_iterationCounter := m_map.next(l_iterationCounter);
    end if;

    if l_iterationCounter is null then
      return false;
    end if;

    return true;
  end;
end;
/
