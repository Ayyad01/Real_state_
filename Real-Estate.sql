use NashvilleHousing
select * from [Nashville Housing Data for Data Cleaning (reuploaded)]
update [Nashville Housing Data for Data Cleaning (reuploaded)]
set SaleDate= CONVERT(date,SaleDate)
--  checking the  null values



select * from [Nashville Housing Data for Data Cleaning (reuploaded)]
-- I  can start with PropertyAddress col to check and remove null if possible
where PropertyAddress is null -- it's 29 rows which affected by the filter 
--  checkinng if the data is possible to remove those null values and not to be crucial in the  analysis
-- I can see null  values also in the yearbuilt and fullBath and  HalfBath and TaxDistrict and OwnerAddress columns  , So I can say  they  are not affecting  the  analysis 
--removing  the null values

delete from [Nashville Housing Data for Data Cleaning (reuploaded)]
where PropertyAddress is null
--checking if the  null values  still existing


select * from [Nashville Housing Data for Data Cleaning (reuploaded)]
where PropertyAddress is null

-- It's gone >>>> Nice
-- checking  the  rest of  null values


select * from [Nashville Housing Data for Data Cleaning (reuploaded)]

-- I need to coordinate the Address column a little bit

select SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as st_address
	, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as  city_address
from [Nashville Housing Data for Data Cleaning (reuploaded)]
-- Now after testing the result  of the  new st_address and  city_address 
             -- making new column added to the dataset


alter table [Nashville Housing Data for Data Cleaning (reuploaded)]
add streetaddress nvarchar(225);
update  [Nashville Housing Data for Data Cleaning (reuploaded)]
set streetaddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)
 

alter table [Nashville Housing Data for Data Cleaning (reuploaded)]
add cityAddress nvarchar(225); 
update [Nashville Housing Data for Data Cleaning (reuploaded)]
set cityAddress = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))
-- selecting the important columns

select UniqueID,streetaddress , cityAddress  ,ParcelID, LandUse , SaleDate,SalePrice ,LegalReference,OwnerAddress,YearBuilt,Bedrooms
from [Nashville Housing Data for Data Cleaning (reuploaded)]
-- those are the  tables I pretend I need to make the useful insights
-- I think I  need  to extract  the street number also 

select SUBSTRING(street_address,1,charindex(' ',streetaddress)) as address
from [Nashville Housing Data for Data Cleaning (reuploaded)]
-- updating the  dataset

alter table [Nashville Housing Data for Data Cleaning (reuploaded)]
add STnumber nvarchar(225);
update [Nashville Housing Data for Data Cleaning (reuploaded)]
set STnumber = SUBSTRING(streetaddress,1,charindex(' ',streetaddress)) 
-- Demonstrating  the new data

select UniqueID,STnumber,streetaddress , cityAddress ,SoldAsVacant ,ParcelID, LandUse , SaleDate,SalePrice ,LegalReference,OwnerAddress,YearBuilt,Bedrooms
from [Nashville Housing Data for Data Cleaning (reuploaded)];
--  I will  check the soldasvanant col


select soldAsVacant , COUNT(SoldAsVacant) as counttt
from [Nashville Housing Data for Data Cleaning (reuploaded)]
group by SoldAsVacant
-- Replacing  o with "NO" and  1 with "YES"


SELECT
    CASE SoldAsVacant
        WHEN 0 THEN 'NO'
        WHEN 1 THEN 'YES'
    END AS SoldAsVacantText
FROM
    [Nashville Housing Data for Data Cleaning (reuploaded)]
--selecting  the  new dataset
-- Adding the new column  to the dataset

alter table [Nashville Housing Data for Data Cleaning (reuploaded)]
add soldvacant varchar(100);

update [Nashville Housing Data for Data Cleaning (reuploaded)]
set soldvacant = 
            CASE SoldAsVacant
             WHEN 0 THEN 'NO'
             WHEN 1 THEN 'YES'
            END 
               
-- It seems  that  it  worked 
-- Nice  till now
CREATE VIEW MY_table AS
  SELECT UniqueID, STnumber, streetaddress, cityAddress, soldvacant,  ParcelID, LandUse, SaleDate, SalePrice, LegalReference, OwnerAddress, YearBuilt, Bedrooms
  FROM [Nashville Housing Data for Data Cleaning (reuploaded)]


-- Removing duplicate values


SELECT UniqueID, STnumber, streetaddress, cityAddress, soldvacant, ParcelID, LandUse, SaleDate, SalePrice, LegalReference, OwnerAddress, YearBuilt, Bedrooms
FROM [Nashville Housing Data for Data Cleaning (reuploaded)]
WHERE LegalReference IN (
    SELECT LegalReference 
    FROM [Nashville Housing Data for Data Cleaning (reuploaded)]
    GROUP BY LegalReference
    HAVING COUNT(*) = 1)
 -- it's funny that it returned only 51433 rows and the  original data was 51448 , the  duplicates are only 15 value
-- And Now  the  data is ready for the analysis on Power BI Dashboarding  Software