--metadb:function loan_count
CREATE OR REPLACE FUNCTION loan_count (
	start_date date DEFAULT '2000-01-01',
	end_date date DEFAULT '2050-01-01')
RETURNS TABLE(
	item_id uuid,
	loan_count bigint) AS
$$
SELECT item_id,
	   count(*) AS loan_count
	 FROM folio_circulation.loan__t
	 WHERE loan_date::DATE >= start_date
         AND loan_date::DATE < end_date
	 GROUP BY item_id
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
