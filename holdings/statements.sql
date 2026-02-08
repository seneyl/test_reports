--metadb:function holdings_statements

DROP FUNCTION IF EXISTS holdings_statements;

CREATE FUNCTION holdings_statements()
RETURNS TABLE(
  instance_hrid as hrid
  holdings_hrid as hrid
  title as text
  holdings_statement as text
  )
AS $$
select 
hs.instance_hrid, 
hs.holdings_hrid,
it.title,
string_agg(hs.public_note, '; ') as holdings_statement
from folio_derived.holdings_statements hs
left join folio_inventory.instance__t it on hs.instance_id = it.id
group by hs.instance_hrid, hs.holdings_hrid, it.title
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
