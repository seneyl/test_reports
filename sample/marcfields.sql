--metadb:function marc_fields

DROP FUNCTION IF EXISTS marc_fields;

CREATE FUNCTION marc_fields()
RETURNS TABLE(
hrid text,
field varchar,
content varchar,
description text
)
AS $$
select
it.hrid,
mt.field,
mt.content,
erl.description
from folio_source_record.marc__t mt
left join folio_inventory.instance__t it on mt.instance_id = it.id 
left join folio_source_record.error_records_lb__ erl on mt.instance_id = erl.id
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
