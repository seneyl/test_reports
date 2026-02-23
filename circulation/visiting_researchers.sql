--metadb:function visiting_researchers

DROP FUNCTION IF EXISTS visiting_researchers;

CREATE FUNCTION visiting_researchers(
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01')
RETURNS TABLE(
    title text,
    loan_date timestamptz
)
AS $$
select 
it.title, 
li.loan_date
from folio_derived.loans_items li
left join folio_inventory.holdings_record__t hrt on li.holdings_record_id = hrt.id
left join folio_inventory.instance__t it on hrt.instance_id::uuid = it.id
where (start_date <= loan_date::date AND loan_date::date < end_date)
and li.patron_group_name = 'VisitingResearchers’
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;

