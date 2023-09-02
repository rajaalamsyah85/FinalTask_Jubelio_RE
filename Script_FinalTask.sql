--creating table promo_code and restore with csv file
CREATE TABLE public.promo_code(
	promo_id INTEGER,
	promo_name VARCHAR(50),
	price_deduction INTEGER,
	description VARCHAR(100),
	duration INTEGER
);

COPY promo_code FROM 
	'E:\Daftar Kerja\Magang\Rakamin\Reporting Engineer - JUBELIO\Week 4\promo_code.csv' 
	(format csv, null "NULL", DELIMITER ',', HEADER);

SELECT *
FROM public.promo_code;

--creating table q3_q4_review and used insert select statement
CREATE TABLE public.q3_q4_review(
	purchase_date DATE, 
	total_price INTEGER, 
	promo_code INTEGER, 
	sales_after_promo INTEGER
);

INSERT INTO public.q3_q4_review(purchase_date, total_price, promo_code, sales_after_promo)
SELECT st.purchase_date, st.quantity * mt.price as total_price, 
	pc.promo_id, (st.quantity * mt.price) - pc.price_deduction as sales_after_promo
FROM public.sales_table st
INNER JOIN public.marketplace_table mt
ON mt.seller_id = st.seller_id
INNER JOIN public.promo_code pc
ON pc.promo_id = st.promo_id
WHERE st.purchase_date BETWEEN '2022-07-01' AND '2022-12-31'
ORDER BY st.purchase_date ASC;

SELECT *
FROM public.q3_q4_review;

-- export table q3_q4_review to csv file
COPY public.q3_q4_review TO 
	'E:\Daftar Kerja\Magang\Rakamin\Reporting Engineer - JUBELIO\Week 4\q3_q4_review.csv' 
	(format csv, null "NULL", DELIMITER ',', HEADER);


--creating shipping_summary and used insert select statement
CREATE TABLE public.shipping_summary(
	shipping_date DATE,
	seller_name VARCHAR(255),
	buyer_name VARCHAR(255),
	buyer_address VARCHAR(255),
	buyer_city VARCHAR(255),
	buyer_zipcode BIGINT,
	kode_resi VARCHAR(255)
);

INSERT INTO public.shipping_summary (shipping_date, seller_name, buyer_name, buyer_address, buyer_city, 
			 	buyer_zipcode, kode_resi)
SELECT shipta.shipping_date, st.seller_name, bt.buyer_name, bt.address, 
	bt.city, bt.zipcode, CONCAT(
		shipta.shipping_id,
        TO_CHAR(shipta.purchase_date, 'YYYYMMDD'),
        TO_CHAR(shipta.shipping_date, 'YYYYMMDD'),
        bt.buyer_id,
        st.seller_id
    ) AS kode_resi
FROM public.shipping_table shipta
INNER JOIN public.seller_table st
ON st.seller_id = shipta.seller_id
INNER JOIN public.buyer_table bt
ON bt.buyer_id = shipta.buyer_id;

SELECT *
FROM public.shipping_summary;

--export shipping_summary to csv file
COPY public.shipping_summary TO 
	'E:\Daftar Kerja\Magang\Rakamin\Reporting Engineer - JUBELIO\Week 4\shipping_summary.csv' 
	(format csv, null "NULL", DELIMITER ',', HEADER);
	

--creating shipping_summary2 only month of december
CREATE TABLE public.shipping_summary2(
	shipping_date DATE,
	seller_name VARCHAR(255),
	buyer_name VARCHAR(255),
	buyer_address VARCHAR(255),
	buyer_city VARCHAR(255),
	buyer_zipcode BIGINT,
	kode_resi VARCHAR(255)
);

INSERT INTO public.shipping_summary2 (shipping_date, seller_name, buyer_name, buyer_address, buyer_city, 
			 	buyer_zipcode, kode_resi)
SELECT shipta.shipping_date, st.seller_name, bt.buyer_name, bt.address, 
	bt.city, bt.zipcode, CONCAT(
		shipta.shipping_id,
        TO_CHAR(shipta.purchase_date, 'YYYYMMDD'),
        TO_CHAR(shipta.shipping_date, 'YYYYMMDD'),
        bt.buyer_id,
        st.seller_id
    ) AS kode_resi
FROM public.shipping_table shipta
INNER JOIN public.seller_table st
ON st.seller_id = shipta.seller_id
INNER JOIN public.buyer_table bt
ON bt.buyer_id = shipta.buyer_id
WHERE EXTRACT(MONTH FROM shipta.shipping_date) = 12
ORDER BY shipta.shipping_date ASC;

SELECT *
FROM public.shipping_summary2;

--export shipping_summary2 to csv file
COPY public.shipping_summary2 TO 
	'E:\Daftar Kerja\Magang\Rakamin\Reporting Engineer - JUBELIO\Week 4\shipping_summary_december.csv' 
	(format csv, null "NULL", DELIMITER ',', HEADER);
