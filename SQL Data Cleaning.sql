--Cleaning Data in SQL Queries

select *
from PortfolioProject1..NashvilleHousing$

--Standardize the date format

select SaleDate, CONVERT(date,SaleDate)
from PortfolioProject1..NashvilleHousing$

update NashvilleHousing$
set SaleDate = CONVERT(date,SaleDate)

Alter table NashvilleHousing$
add saledatechanged Date;

select saledatechanged, CONVERT(time,saledate)
from PortfolioProject1..NashvilleHousing$

update NashvilleHousing$
set saledatechanged = CONVERT(date,SaleDate)

--populate Property Address data

select *
from PortfolioProject1..NashvilleHousing$
--where PropertyAddress is null
order by ParcelID

--we are replacing proprtyaddress data into null values using JOIN,ISNULL

select ab.ParcelID,ab.PropertyAddress,bc.ParcelID,bc.PropertyAddress,ISNULL(ab.PropertyAddress,bc.PropertyAddress)
from PortfolioProject1..NashvilleHousing$ ab
join PortfolioProject1..NashvilleHousing$ bc
on ab.ParcelID = bc.ParcelID
and ab.[UniqueID] <> bc.[UniqueID]
where ab.PropertyAddress is  null

update ab
set PropertyAddress = ISNULL(ab.PropertyAddress,bc.PropertyAddress)
from PortfolioProject1..NashvilleHousing$ ab
join PortfolioProject1..NashvilleHousing$ bc
on ab.ParcelID = bc.ParcelID
and ab.[UniqueID] <> bc.[UniqueID]
where ab.PropertyAddress is  null


--breaking out address into individual columns bu using ','

select PropertyAddress
from PortfolioProject1..NashvilleHousing$
--where PropertyAddress is null

select
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress)) as Address1
from PortfolioProject1..NashvilleHousing$
--where UniqueID = '2045'

alter table NashvilleHousing$
add propertysplitaddress nvarchar(255);

update NashvilleHousing$
set propertysplitaddress =  SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)


alter table NashvilleHousing$
add propertysplitcity nvarchar(255);

update NashvilleHousing$
set propertysplitcity =  SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress))

select *
from PortfolioProject1..NashvilleHousing$

--Separating data into columns

select OwnerAddress
from PortfolioProject1..NashvilleHousing$
where OwnerAddress is not null

select 
PARSENAME(replace(OwnerAddress, ',','.'),1),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),3)
from PortfolioProject1..NashvilleHousing$
where OwnerAddress is not null

alter table NashvilleHousing$
add State varchar(255);

update NashvilleHousing$
set state = PARSENAME(replace(OwnerAddress, ',','.'),1)

alter table NashvilleHousing$
add city varchar(255);

update NashvilleHousing$
set city = PARSENAME(replace(OwnerAddress, ',','.'),2)

alter table NashvilleHousing$
add ownerdnoaddress nvarchar(255);

update NashvilleHousing$
set ownerdnoaddress = PARSENAME(replace(OwnerAddress, ',','.'),3)

select * 
from PortfolioProject1..NashvilleHousing$

--change Y and N to yes or No in 'solid as vacant' column

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject1..NashvilleHousing$
group by SoldAsVacant
order by 2

select SoldAsVacant,
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 
from PortfolioProject1..NashvilleHousing$

update NashvilleHousing$
set SoldAsVacant =
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 


-- Removing dupelicates

with rownumCTE as (
select *,
ROW_NUMBER() over (
partition by parcelid,
			saledate,
			saleprice,
			propertyaddress,
			legalreference
			order by uniqueid
			) row_num

from PortfolioProject1..NashvilleHousing$
--order by ParcelID
)
select * 
from rownumCTE
where row_num>1
order by PropertyAddress

--Deleting Duplicates

with rownumCTE as (
select *,
ROW_NUMBER() over (
partition by parcelid,
			saledate,
			saleprice,
			propertyaddress,
			legalreference
			order by uniqueid
			) row_num

from PortfolioProject1..NashvilleHousing$
--order by ParcelID
)
Delete 
from rownumCTE
where row_num>1
--order by PropertyAddress


---Deleting unused columns

Select *
From PortfolioProject1..NashvilleHousing$


ALTER TABLE PortfolioProject1..NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From PortfolioProject1..NashvilleHousing$