/*

Cleaning Data in SQL Queries

*/

-- import excel.CSV ke phpmyadmin 
-- ganti tipe data semua kolom dan sesuaikan 

--------------------------------------------------------------------------------------------------------------------------

USE covidprojectporto

SELECT * FROM nashvillehouse


--------------------------------------------------------------------------------------------------------------------------

-- ganti format di sale date menjadi date (jika di phpmyadminerror)

SELECT saledate 
FROM nashvillehouse 

UPDATE nashvillehouse
SET saledate = STR_TO_DATE(saledate, '%m/%d/%Y');



 --------------------------------------------------------------------------------------------------------------------------

-- cek duplikat data 

SELECT parcelid, propertyaddress, COUNT(*) AS jumlah_duplikat
FROM nashvillehouse
GROUP BY parcelid, propertyaddress
HAVING COUNT(*) > 1;

-- Populate Property Address data

-- cari dan pilih data yang duplicate yang ingin di mergered
SELECT a.ParcelID AS ParcelID_a, COALESCE(a.PropertyAddress, b.PropertyAddress) AS MergedPropertyAddress
FROM nashvillehouse a
JOIN nashvillehouse b
ON  a.parcelid = b.parcelid 
    AND a.uniqueid <> b.UniqueID
WHERE
    a.propertyaddress IS NULL OR b.propertyaddress IS NULL 

-- setelah selesai update data yang di mergered tadi
UPDATE nashvillehouse a
JOIN nashvillehouse b
ON  a.parcelid = b.parcelid 
    AND a.uniqueid <> b.UniqueID
SET a.propertyaddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.propertyaddress IS NULL OR b.propertyaddress IS NULL;


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT
  SUBSTRING(propertyaddress, 1, LOCATE(',', propertyaddress) - 1) AS address,
  SUBSTRING(propertyaddress, LOCATE(',', propertyaddress) + 1, LENGTH(propertyaddress)) AS city_and_state
FROM
  nashvillehouse

-- Menambahkan kolom baru ke tabel
ALTER TABLE nashvillehouse
ADD COLUMN address VARCHAR(255), -- Sesuaikan tipe data dan panjang kolom sesuai kebutuhan

ADD COLUMN city_and_state VARCHAR(255);

-- Mengupdate nilai kolom baru dengan hasil ekstraksi
UPDATE nashvillehouse
SET
  address = SUBSTRING(propertyaddress, 1, LOCATE(',', propertyaddress) - 1),
  city_and_state = SUBSTRING(propertyaddress, LOCATE(',', propertyaddress) + 1, LENGTH(propertyaddress));
  
  SELECT * FROM nashvillehouse 

-- membagi alamat owneraddress

SELECT
SUBSTRING(owneraddress, 1, LOCATE(',', propertyaddress) - 1) AS address,
-- Mengambil alamat (sebelum koma pertama)Mengambil sebagian 
-- dari owneraddress mulai dari karakter pertama hingga sebelum koma pertama.
    
SUBSTRING(owneraddress,LOCATE(',', owneraddress) + 2,LOCATE(',', owneraddress, LOCATE(',', owneraddress) + 1) - LOCATE(',', propertyaddress) - 2) AS city,
-- Mengambil kota (setelah koma pertama dan sebelum koma kedua)
-- Mengambil sebagian dari owneraddress mulai dari karakter setelah koma pertama hingga sebelum koma kedua  
    

SUBSTRING(owneraddress, LOCATE(',', owneraddress, LOCATE(',', owneraddress) + 1) + 2, 
LENGTH(owneraddress)) AS state
-- Mengambil negara bagian (setelah koma kedua)
-- Mengambil sebagian dari owneraddress mulai dari karakter setelah koma kedua hingga akhir string.
FROM nashvillehouse 

SELECT * FROM nashvillehouse

-- Menambahkan kolom baru ke tabel
ALTER TABLE nashvillehouse
ADD COLUMN addressow VARCHAR(255),  -- Sesuaikan tipe data dan panjang kolom sesuai kebutuhan
ADD COLUMN cityowner VARCHAR(255),
ADD COLUMN stateowner VARCHAR(255);

-- Mengupdate nilai kolom baru berdasarkan pemisahan alamat, kota, dan negara bagian
UPDATE nashvillehouse
SET
    addressow = SUBSTRING(owneraddress, 1, LOCATE(',', owneraddress) - 1),
    cityowner = SUBSTRING(
        owneraddress,
        LOCATE(',', owneraddress) + 2,
        LOCATE(',', owneraddress, LOCATE(',', owneraddress) + 1) - LOCATE(',', owneraddress) - 2
    ),
    stateowner = SUBSTRING(
        owneraddress,
        LOCATE(',', owneraddress, LOCATE(',', owneraddress) + 1) + 2,
        LENGTH(owneraddress)
    );

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashvillehouse
GROUP BY soldasvacant


-- Mengupdate kolom soldasvacant dan mengganti hurufnya menjadi seragam
UPDATE nashvillehouse
SET soldasvacant = CASE 
                      WHEN LOWER(soldasvacant) = 'Y' THEN 'Yes'
                      WHEN LOWER(soldasvacant) = 'N' THEN 'No'
                      ELSE soldasvacant  -- Jika nilai tidak Y atau N, biarkan nilainya tidak berubah
                   END;
                   

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

SELECT * FROM nashvillehouse 

WITH rownumCTE AS (
SELECT *,
       ROW_NUMBER() OVER(
           PARTITION BY parcelid,
                            propertyaddress,
                            saleprice,
                            saledate,
                            legalreference
         ORDER BY uniqueid) AS RowNum
FROM nashvillehouse
)
SELECT * 
FROM rownumCTE
WHERE rownum >1
ORDER BY propertyaddress 

DELETE FROM nashvillehouse
WHERE (parcelid, propertyaddress, saleprice, saledate, legalreference, uniqueid) IN (
    SELECT parcelid, propertyaddress, saleprice, saledate, legalreference, uniqueid
    FROM (
        SELECT parcelid,
               propertyaddress,
               saleprice,
               saledate,
               legalreference,
               uniqueid,
               ROW_NUMBER() OVER (PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference ORDER BY uniqueid) AS RowNum
        FROM nashvillehouse
    ) AS subquery
    WHERE RowNum > 1
);


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT * FROM nashvillehouse 

ALTER TABLE nashvillehouse 
DROP COLUMN owneraddress, 
DROP COLUMN taxdistrict, 
DROP COLUMN propertyaddress;












-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it





---- Using BULK INSERT




---- Using OPENROWSET

















