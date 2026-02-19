--metadb:function marc_fields

DROP FUNCTION IF EXISTS marc_fields;

CREATE FUNCTION marc_fields()
RETURNS TABLE(
hrid text,
field varchar,
content varchar,
field2 text
)
AS $$
select
it.hrid,
mt.field,
mt.content,
mt2.field as field2
from folio_source_record.marc__t mt
left join folio_inventory.instance__t it on mt.instance_id = it.id 
left join folio_source_record.marc__t mt2 on mt.instance_id = mt2.instance_id
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
