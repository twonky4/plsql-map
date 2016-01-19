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
      if m_map(l_i).m_key = pi_key or (pi_key is null and m_map(l_i).m_key is null) then
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
      if m_map(l_i).m_key = pi_key or (pi_key is null and m_map(l_i).m_key is null)then
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
      if m_map(l_i).m_key = pi_key or (pi_key is null and m_map(l_i).m_key is null) then
        return true;
      end if;

      l_i := m_map.next(l_i);
    end loop;

    return false;
  end;

  member function containsValue(pi_value varchar2) return boolean is
    l_i number;
  begin
    l_i := m_map.first();
    while (l_i is not null)
    loop
      if m_map(l_i).m_value = pi_value or (pi_value is null and m_map(l_i).m_value is null) then
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

  member procedure nextEntry is
  begin
    if m_iterationCounter = -1 then
      m_iterationCounter := self.m_map.first();
    else
      m_iterationCounter := self.m_map.next(m_iterationCounter);
    end if;
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

  member procedure removeCurrent is
    l_iterationCounter number := m_iterationCounter;
  begin
    if l_iterationCounter = -1 then
      l_iterationCounter := m_map.first();
    end if;

    if l_iterationCounter is not null and m_map.exists(l_iterationCounter) then
      m_map.delete(l_iterationCounter);
    end if;
  end;

  member function removeCurrent(self in out t_map) return t_map_entry is
    l_entry t_map_entry;
    l_iterationCounter number := m_iterationCounter;
  begin
    if l_iterationCounter = -1 then
      l_iterationCounter := self.m_map.first();
    end if;

    if l_iterationCounter is not null and m_map.exists(l_iterationCounter) then
      l_entry := m_map(l_iterationCounter);
      m_map.delete(l_iterationCounter);
      return l_entry;
    end if;

    return null;
  end;

  member procedure setCurrentValue(pi_value varchar2) is
    l_iterationCounter number := m_iterationCounter;
  begin
    if l_iterationCounter = -1 then
      l_iterationCounter := self.m_map.first();
    end if;

    if l_iterationCounter is not null and m_map.exists(l_iterationCounter) then
      m_map(l_iterationCounter).m_value := pi_value;
    end if;
  end;

  member function setCurrentValue(self in out t_map, pi_value varchar2) return varchar2 is
    l_last_value varchar2(32767);
    l_iterationCounter number := m_iterationCounter;
  begin
    if l_iterationCounter = -1 then
      l_iterationCounter := self.m_map.first();
    end if;

    if l_iterationCounter is not null and m_map.exists(l_iterationCounter) then
      l_last_value := m_map(l_iterationCounter).getValue();
      m_map(l_iterationCounter).m_value := pi_value;
      
      return l_last_value;
    end if;
    
    return null;
  end;
end;
/
