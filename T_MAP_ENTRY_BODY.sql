create or replace type body t_map_entry is
  member function getKey return varchar2 is
  begin
    return m_key;
  end;

  member function getValue return varchar2 is
  begin
    return m_value;
  end;
end;
/