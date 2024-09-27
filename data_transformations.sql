SELECT transaction_date 
FROM sera.sales_txn;

-- String manipulation 1, - Date
SELECT transaction_date, 
TO_TIMESTAMP(TRIM(SUBSTRING(transaction_date, 1, 14)), 'Mon DDth, YYYY HH:MI:SS AM') AS datetime
FROM sera.sales_txn;

-- String manipulation 2, - Card Type 
SELECT card_type,
CASE
	WHEN card_type LIKE 'visa%' THEN 'visa'
	WHEN card_type LIKE 'mastercard%' THEN 'mastercard'
	WHEN card_type LIKE 'verve%' THEN 'verve'
	ELSE card_type
END AS card_type_group
FROM sera.sales_txn;

-- String manipulaton 3, - credit or debit 
SELECT card_type,
CASE
	WHEN LOWER (card_type) LIKE '%credit%' THEN 'credit'
	WHEN LOWER (card_type) LIKE '%debit%' THEN 'debit'
	ELSE 'other'
END AS credit_or_debit
FROM sera.sales_txn;

-- String manipulation 4, - combination of all transformation as 1
CREATE VIEW sales AS (
	SELECT reference, 
	TO_TIMESTAMP(TRIM(SUBSTRING(transaction_date, 1, 14)), 'Mon DDth, YYYY HH:MI:SS AM') AS datetime, 
	user_id, 
	amount, 
	gateway_response,
	transaction_id, 
	card_type,  
	CASE 
		WHEN card_type LIKE 'visa%' THEN 'visa'
		WHEN card_type LIKE 'mastercard%' THEN 'mastercard'
		WHEN card_type LIKE 'verve%' THEN 'verve'
		ELSE card_type
	END AS card_type_group,
	CASE
		WHEN LOWER (card_type) LIKE '%credit%' THEN 'credit'
		WHEN LOWER (card_type) LIKE '%debit%' THEN 'debit'
		ELSE 'other'
	END AS credit_or_debit,
	card_bank, 
	country_code,
	currency, 
	source, 
	status, 
	channel
	FROM sera.sales_txn
);