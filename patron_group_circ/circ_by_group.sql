--metadb:function circ_by_group

DROP FUNCTION IF EXISTS circ_by_group;

CREATE FUNCTION circ_by_group(
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01'
    patron_group_search text default ''
  )
RETURNS TABLE(
  patron_group_name text, 
  barcode text,
  loan_date timestamptz,
  title text
)
AS $$
select 
li.patron_group_name as patron_group,
li.barcode,
li.loan_date,
it.title
from folio_derived.loans_items li
left join folio_inventory.holdings_record__t hrt on li.holdings_record_id = hrt.id
left join folio_inventory.instance__t it on hrt.instance_id::uuid = it.id
where (start_date <= loan_date::date AND loan_date::date < end_date)
and li.patron_group_name ilike Concat('%',patron_group_search,'%')
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
