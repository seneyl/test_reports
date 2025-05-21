SQL
--metadb:function missing_items_by_location
drop function if exists missing_items_by_location;

create function missing_items_by_location()
returns table(
item_status text,
item_location text,
item_barcode text,
call_number text,
enumeration text,
volume text,
copy_number text,
title text
)
as $$
SELECT
i.jsonb -> 'status' ->> 'name' AS item_status,
loc.name AS item_location,
i.jsonb ->> 'barcode' AS item_barcode,
i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_number,
i.jsonb ->> 'enumeration' AS enumeration,
i.jsonb ->> 'volume' AS volume,
i.jsonb ->> ' copyNumber' AS copy_number,
inst.title AS title
FROM folio_inventory.item i
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
WHERE i.jsonb -> 'status' ->> 'name' = 'Missing';
$$
language sql
stable 
parallel safe;
