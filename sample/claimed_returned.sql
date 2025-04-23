--metadb:function claimed_returned

-- Report pulls a list of items with the status of claimed returned, 
-- with the ability to filter by library.

DROP FUNCTION IF EXISTS claimed_returned;

CREATE FUNCTION claimed_returned(
	/* Enter a FOLIO item locations */
	item_location text)
RETURNS TABLE(
	claimed_date timestamptz,
	item_barcode text,
	library text,
	item_location text,
	call_number text,
	copy text,
	vol text,
	claim_note text,
	loan_id uuid,
	patron_barcode text,
	user_id text)
AS $$
SELECT
	(i.jsonb -> 'status' ->> 'date')::DATE as claimed_date,
	i.jsonb ->> 'barcode' as item_barcode,
	lt2."name" as library,
	lt."name"  as item_location,
	holdings."call_number",
	i.jsonb ->> 'copyNumber' AS copy,
	i.jsonb ->> 'volume' AS volume,
	l.jsonb ->> 'actionComment' as claim_note,
	l.jsonb ->> 'id' AS loan_id,
	u.barcode as patron_barcode,
	l.jsonb ->> 'userId' AS user_id
FROM folio_circulation.loan l
LEFT JOIN folio_inventory.item i on i.id = (l.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users__t as u on u.id = (l.jsonb ->> 'userId')::uuid
LEFT JOIN folio_inventory.location__t lt  on lt.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.loclibrary__t lt2 on lt2.id = lt.library_id
LEFT JOIN folio_inventory.holdings_record__t as holdings on holdings.id = i.holdingsrecordid
where i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
	AND l.jsonb ->> 'itemStatus' = 'Claimed returned'
	AND l.jsonb ->> 'action' = 'claimedReturned'
	AND lt."name" ilike concat('%' ,item_location, '%')
ORDER BY claimed_date asc
$$
language sql
stable
parallel safe;
