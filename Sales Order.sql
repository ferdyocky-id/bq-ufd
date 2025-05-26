with sales_data as
(
select
  a.so_date, a.picking_date, a.wh_desc, a.store,
  a.inv_no, a.do_no, a.expedition, a.status_name,
  a.sku_variant, a.msku, a.size, a.qty, a.price
from
  urban-fashion-digital-dwh.tf_db.sales as a
left join
  urban-fashion-digital-dwh.tf_db.sales_ret as b
  on a.inv_no = b.inv_no
  and a.sku_variant = b.sku_variant
where
  b.inv_no is null
  and b.sku_variant is null
),

sales_data_join as
(
select
  a.* except(wh_desc, store, msku),
  b.* except(wh_desc),
  c.* except(store_source),
  d.*

from
  sales_data as a

left join
  urban-fashion-digital-dwh.tf_db.warehouse as b
  on a.wh_desc = b.wh_desc
left join
  urban-fashion-digital-dwh.tf_db.store_channel as c
  on a.store = c.store_source
left join
  urban-fashion-digital-dwh.tf_db.master_sku as d
  on a.msku = d.msku
)

select
  *
from
  sales_data_join
where
  brand not in ('Department', 'Strive', 'Goodr')
  and status_name not in ('RETURN', 'CANCEL')